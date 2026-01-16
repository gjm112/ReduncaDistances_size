function [fold_test, fold_train, fold_PCtest, fold_PCtrain, fold_test_overall, fold_train_overall, fold_PCtest_overall, fold_PCtrain_overall] = TrainTestFeatures(data, cat_vec, train_ind, test_ind)
%data:2xpxn array containing the curves
%cat_vec: is an n length vector with the categories we would
%like to classify by
%train_ind: vector with indicators if an observation is in the training
%data

%this gives the number of matrices/curves we have in our dataset
n=size(cat_vec,1);

%this is a vector with the number of matrives/curves we have in each of the
%categories we would like to classify by 
size_cats = groupcounts(cat_vec);

%this is the number of categories we have 
n_cats = length(size_cats);

%get the labels of the categories 
tbl = tabulate(cat_vec);
names_cats = string(tbl(:,1));

%% Get the training and test data, find training's overall mean 

%this gives the number of points we havae on each curve
p=size(data,2);

%this is the number of categories we have 
m = length(names_cats);

%get training data
train_data = data(:,:,train_ind);
test_data = data(:,:,(test_ind));

%this puts each of the curves into SRVF form 
%figure(1); clf; 
for i=1:n
    X = ReSampleCurve(data(:,:,i),100);
    q(:,:,i) = curve_to_q(X);
end
train_q = q(:,:,train_ind);
test_q = q(:,:,test_ind);

%find the overall mean of the training data 
mean_overall = FindElasticMeanFast(train_data);

%% Project each observation onto the mean of the training data in each category

%storage for the coordinates 
coords = NaN(n,2*p*m);

%all the possible indexes in the training data 
indexes = 1:size(train_data,3);

for i=1:m
  %get the indexes of the obs in the training data in the ith category 
  cat_index = indexes(cat_vec(train_ind==1)==names_cats(i));

  %find the mean of the training objects in category i 
  mean_cat = FindElasticMeanFast_intialized(train_data(:,:,cat_index),mean_overall);
  
  %store category mean
  store_means(:,:,i) = mean_cat;

  %for each curve in the sample, get the shooting vector from the category mean 
  %to the curve and save the coordinates  
  for j=1:n
    %make sure everything is in SRVF
    X = ReSampleCurve(data(:,:,j),p);
    q = curve_to_q(X);
    
    tmp = ElasticShootingVectorFast(mean_cat,q,1);
    %in row j, cols 1 to p, place the x cords of v
    %in row j, cols p+1 to 2*p, place the y cords of v 
    coords(j,((2*(i-1)*p+1):(2*i*p))) = [tmp(1,:),tmp(2,:)];
  end
end

%split coords into test and train subset
fold_test = coords(train_ind~=1,:);
fold_train = coords(train_ind==1,:);

%% Get features using PCs based on category means of training data 

%get smallest number of observations in a cateogory in this fold 
tab_cats = tabulate(cat_vec(train_ind,:));
counts_cats = cell2mat(tab_cats(:,2));
Ured_numcol = min(counts_cats)-1;

%features storage
fold_PCtrain = NaN(sum(train_ind), Ured_numcol*m);
fold_PCtest = NaN(sum(test_ind), Ured_numcol*m);

for i=1:m
  %get the indexes of the obs in the training data in the ith category 
  cat_index = indexes(cat_vec(train_ind==1)==names_cats(i));

  %find the mean of the training objects in category i 
  mean_cat = store_means(:,:,i);
  
  %for each curve in the training sample, get the shooting vector from category mean
  %to the curve register each of these curves to mu
  for j=1:size(train_data,3)
     tmp = ElasticShootingVectorFast(mean_cat,train_q(:,:,j),1);
      %in row i, cols 1 to b, place the x cords of v
      %in row i, cols b+1 to 2*b, place the y cords of v 
      VV(j,1:p) = tmp(1,:);
      VV(j,p+1:2*p) = tmp(2,:);
  end
  
  %covariance of VV
  K = cov(VV);
  %singluar value decomp of VV 
  %V is U^T
  %S is Sigma, has n-1 non-zero diagonal elements
  [U,S,V] = svd(K);
    
  %reduce U to number of columns equal to the sample size of the smallest
  %category in this group - 1
  Ured = U(:,1:Ured_numcol);
  
  %get the features for the training data 
  fold_PCtrain(:,((1+(i-1)*Ured_numcol):(i*Ured_numcol)))= VV*Ured;

    %get the features for test data 
    for j=1:size(test_data,3)
        tmp = ElasticShootingVectorFast(mean_cat,test_q(:,:,j),1);
        %in row i, cols 1 to b, place the x cords of v
        %in row i, cols b+1 to 2*b, place the y cords of v 
        VV_test(j,1:p) = tmp(1,:);
        VV_test(j,p+1:2*p) = tmp(2,:);
    end

    fold_PCtest(:,((1+(i-1)*Ured_numcol):(i*Ured_numcol))) = VV_test*Ured;
end
%% Project each observation onto the overall mean of the training data 

%storage for the coordinates
coords_overall = NaN(n,2*p);

%for each curve in the sample, get the shooting vector from the training mean 
%to the curve and save the coordinates  
for j=1:n
    %make sure everything is in SRVF
    X = ReSampleCurve(data(:,:,j),p);
    q = curve_to_q(X);

    tmp = ElasticShootingVectorFast(mean_overall,q,1);
    %in row j, cols 1 to p, place the x cords of v
    %in row j, cols p+1 to 2*p, place the y cords of v 
    coords_overall(j,:) = [tmp(1,:),tmp(2,:)];
end

%split coords into test and train subset
fold_test_overall = coords_overall(train_ind~=1,:);
fold_train_overall = coords_overall(train_ind==1,:);

%% Get features using PCs based on overall mean of training data 

%for each curve in the training sample, get the shooting vector from overall mean
%to the curve register each of these curves to mu
for i=1:size(train_data,3)
    tmp = ElasticShootingVectorFast(mean_overall,train_q(:,:,i),1);
    %in row i, cols 1 to b, place the x cords of v
    %in row i, cols b+1 to 2*b, place the y cords of v 
    VV(i,1:p) = tmp(1,:);
    VV(i,p+1:2*p) = tmp(2,:);
end

%covariance of VV
K = cov(VV);
%singluar value decomp of VV 
%V is U^T
%S is Sigma, has n-1 non-zero diagonal elements
[U,S,V] = svd(K);

%reduce U to the columns which account for 0.99 of the variablility
Ured_numcol = sum(cumsum(diag(S))/sum(diag(S)) <= 0.99);
Ured = U(:,1:Ured_numcol);

%get the features for the training data 
fold_PCtrain_overall = VV*Ured;

%get the features for test data 
for i=1:size(test_data,3)
    tmp = ElasticShootingVectorFast(mean_overall,test_q(:,:,i),1);
    %in row i, cols 1 to b, place the x cords of v
    %in row i, cols b+1 to 2*b, place the y cords of v 
    VV_test(i,1:p) = tmp(1,:);
    VV_test(i,p+1:2*p) = tmp(2,:);
end

fold_PCtest_overall = VV_test*Ured;
end
