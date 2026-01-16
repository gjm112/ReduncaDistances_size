%running classification for just one fold
%the data for this is in LM1_data_20210622.mat

%% Set Up 

%set a seed
rng(13434);

%data:2xpxn array containing the curves
data = LM1_teeth; 

%cat_vec: is an n length vector with the categories we would like to classify by
cat_vec = LM1_ref.tribe; 

%k: number of folds
k=5;

%% Split into folds and get indicator of training data for fold 1

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

%vector with what fold each observation is in 
folds = NaN(n,1);

%all the possible indexes
indexes = 1:n;

for i=1:n_cats
  %get the indexes (row/col num) of the obs in the ith category 
  cat_index = indexes(cat_vec==names_cats(i));
  
  %shuffle them so they are in a random order
  shuffled_cat_index = cat_index(randperm(length(cat_index)));
  
  %initialize a grouping vector for this category
  cat_folds = zeros(length(cat_index),1);
  
  %amount per group besides last one 
  fold_size = ceil(length(cat_index)/k);
  
  %assign groups to shuffled category observations
  for j=1:(k-1)
   cat_folds((1+(j-1)*fold_size):(fold_size*j)) = j;
  end
  
  cat_folds((1+(k-1)*fold_size):length(cat_folds)) = k;
  
  %assign group to appropriate spot in grouping based in indexes 
  folds(shuffled_cat_index) = cat_folds;
end

%vector with indicators of an obs being in the training data 
% obs not assigned to fold 1 are in training data
train_ind = (folds ~= 1);
test_ind = (folds ==1);

%split cat_vec into the test and train subsets for this fold
cat_vec_test = cat_vec(folds==1);
cat_vec_train = cat_vec(folds~=1);

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
fold_test = coords(folds==1,:);
fold_train = coords(folds~=1,:);

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
fold_test_overall = coords_overall(folds==1,:);
fold_train_overall = coords_overall(folds~=1,:);

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

%% Classification with Random Forest
%number of trees
NumTrees=50;

%fit on training data
fold_rf_fit = TreeBagger(NumTrees, fold_train, cat_vec_train);
fold_rf_fit_overall = TreeBagger(NumTrees, fold_train_overall, cat_vec_train);
fold_PCrf_fit = TreeBagger(NumTrees, fold_PCtrain, cat_vec_train);
fold_PCrf_fit_overall = TreeBagger(NumTrees, fold_PCtrain_overall, cat_vec_train);

%get predictions for testing data 
fold_rf_preds = categorical(predict(fold_rf_fit, fold_test));
fold_rf_preds_overall = categorical(predict(fold_rf_fit_overall, fold_test_overall));
fold_PCrf_preds = categorical(predict(fold_PCrf_fit, fold_PCtest));
fold_PCrf_preds_overall = categorical(predict(fold_PCrf_fit_overall, fold_PCtest_overall));

%get prediction accuracy 
accs_rf = sum(fold_rf_preds ==  cat_vec_test)/size(fold_rf_preds,1);
accs_rf_overall = sum(fold_rf_preds_overall ==  cat_vec_test)/size(fold_rf_preds_overall,1);
accs_PCrf = sum(fold_PCrf_preds ==  cat_vec_test)/size(fold_PCrf_preds,1);
accs_PCrf_overall = sum(fold_PCrf_preds_overall ==  cat_vec_test)/size(fold_PCrf_preds_overall,1);

%% Classification with SVM 

%fit on training data
fold_svm_fit = fitcecoc(fold_train, cat_vec_train);
fold_svm_fit_overall = fitcecoc(fold_train_overall, cat_vec_train);
fold_PCsvm_fit = fitcecoc(fold_PCtrain, cat_vec_train);
fold_PCsvm_fit_overall = fitcecoc(fold_PCtrain_overall, cat_vec_train);

%get predictions for testing data 
fold_svm_preds = categorical(predict(fold_svm_fit, fold_test));
fold_svm_preds_overall = categorical(predict(fold_svm_fit_overall, fold_test_overall));
fold_PCsvm_preds = categorical(predict(fold_PCsvm_fit, fold_test));
fold_PCsvm_preds_overall = categorical(predict(fold_PCsvm_fit_overall, fold_PCtest_overall));

%get prediction accuracy 
accs_svm = sum(fold_svm_preds ==  cat_vec_test)/size(fold_svm_preds,1);
accs_svm_overall = sum(fold_svm_preds_overall ==  cat_vec_test)/size(fold_svm_preds_overall,1);
accs_PCsvm = sum(fold_PCsvm_preds ==  cat_vec_test)/size(fold_PCsvm_preds,1);
accs_PCsvm_overall = sum(fold_PCsvm_preds_overall ==  cat_vec_test)/size(fold_PCsvm_preds_overall,1);

%% Nearest Neighbors, k=1

%matrix of pairwise distances
pd_mat = LM1dmat;

%all the possible indexes
indexes = 1:n;

%get ids of training and testing data
train_ids = indexes(folds~=1);
test_ids = indexes(folds==1);

%sort each row of the distance matrix
%save the sorted matrix as sorted_pd and the started indexes of each sorted
%item as id_sorted_pd
[sorted_pd,id_sorted_pd] = sort(pd_mat,2);

%for each row for a test data, finds it's nearest neighbor in the training
%data 

%storage
nn_id = zeros(size(test_ids,1));

%storage position
j=1;

for i=test_ids
    %extract ids of the ith row of the pairwise distance matrix
   row_i = id_sorted_pd(i,:);
   
   %this will give me the id of the first train_id that shows up in the row
   %this is the train_id with the shortest distance to this obs in the test
   %dataset
   position_nn = find(row_i.*ismember(row_i,train_ids),1,'first');
   
   %extract that id 
   nn_id(j) = row_i(position_nn);
   
   j=j+1;
end

%get the type assigned to each obs in the test dataset 
cat_assgn = cat_vec(nn_id);

%get the true type of each obs in the test dataset 
true_cat = cat_vec(test_ids);

%this gives an array with 1's where the correct type was given 
correct_vec = cat_assgn == true_cat;

%what percent of classifications where correct?
accs_nn1 = sum(correct_vec)/size(correct_vec,1);

%% Nearest Neighbors, k=3

%for each row for a test data, finds it's three nearest neighbors in the
%training data 

%storage
nn_ids = zeros(size(test_ids,1),3);

%storage position
j=1;

for i=test_ids
    %extract ids of the ith row of the pairwise distance matrix
   row_i = id_sorted_pd(i,:);
   
   %this will give me the ids of the first 3 train_id that shows up in the row
   %this is the 3 train_ids with the shortest distance to this obs in the test
   %dataset
   position_nn = find(row_i.*ismember(row_i,train_ids),3,'first');
   
   %extract that id 
   nn_ids(j,:) = row_i(position_nn);
   
   j=j+1;
end

%get the cats assigned to each of the neighbors 
nn_cats = cat_vec(nn_ids);

%get the assigned category for each of the test obs
cat_assgn = string(zeros(length(test_ids),1));

for i=1:length(test_ids)
    if nn_cats(i,2) == nn_cats(i,3) && nn_cats(i,1) ~= nn_cats(i,2)
        %if 2=3 and 2 ne 1, assign cat 2
        cat_assgn(i) = nn_cats(i,2);
    else 
        %if all the same, 1=2, 1=3, or they are all different, assign cat 1 
        %if none of the categories are equal, assign 1st cat because that
        %is the closest because of how pd_mat is sorted
        cat_assgn(i) = nn_cats(i,1);
    end
end

%get the true type of each obs in the test dataset 
true_cat = string(cat_vec(test_ids));

%this gives an array with 1's where the correct type was given 
correct_vec = cat_assgn == true_cat;

%what percent of classifications where correct?
accs_nn3 = sum(correct_vec)/size(correct_vec,1);

%% Nearest Neighbors, k=5

%storage
nn_ids = zeros(size(test_ids,1),5);

%storage position
j=1;

for i=test_ids
    %extract ids of the ith row of the pairwise distance matrix
   row_i = id_sorted_pd(i,:);
   
   %this will give me the ids of the first 5 train_id that show up in the row
   %this is the 5 train_ids with the shortest distance to this obs in the test
   %dataset
   position_nn = find(row_i.*ismember(row_i,train_ids),5,'first');
   
   %extract that id 
   nn_ids(j,:) = row_i(position_nn);
   
   j=j+1;
end

%get the cats assigned to each of the neighbors 
nn_cats = cat_vec(nn_ids);

%get the assigned category for each of the test obs
cat_assgn = string(zeros(length(test_ids),1));

for i=1:length(test_ids)
    %get table with categories as value and count of each cat as count 
    tab_cats = cell2table(tabulate(nn_cats(i,:)),'VariableNames',{'Value','Count','Percent'});
    tab_cats.Value = string(tab_cats.Value);
    %get the maximum count and it's row in tab_cats 
    [M,I] = max(tab_cats.Count);
    
    if ismember(M,3:5)==1
        %if max is 3,4, or 5, set cat_assign to the category with that
        %count
        cat_assgn(i) = tab_cats.Value(I);
    elseif M==2
        %if max is 2, assign cat based on if there is one or two pairs
        if sum(tab_cats.Count==2)==1
           %if there is only one pair assign to category with 2 counts
           cat_assgn(i) = tab_cats.Value(I);
        else
           %if there is two pairs, take the average distance of both pairs and assign
           %cat with smallest average 
           %because of how pd_mat is sorted, and thus nn_cats, this will be
           %the category with the smallest average position in nn_cats
           
           %extract the categories that occur twice
           twice_cats = tab_cats.Value(tab_cats.Count==2,:);
           
           %get the mean id of both categories that occur twice
           meanid_cat1 = mean(find(ismember(nn_cats(i,:), twice_cats(1)))); 
           meanid_cat2 = mean(find(ismember(nn_cats(i,:), twice_cats(2))));
           
           %assign cat with smallest mean id
           if meanid_cat1 < meanid_cat2
               cat_assgn(i) = twice_cats(1);
           else 
               cat_assgn(i) = twice_cats(2);
           end
        end
    else M==1    
        %assign cat with smallest distance 
        %because of how pd_mat is sorted, this is the cat of the first
        %element in the row
        cat_assgn(i) = nn_cats(i,1);
    end
end

%get the true type of each obs in the test dataset 
true_cat = string(cat_vec(test_ids));

%this gives an array with 1's where the correct type was given 
correct_vec = cat_assgn == true_cat;

%what percent of classifications where correct?
accs_nn5 = sum(correct_vec)/size(correct_vec,1);
