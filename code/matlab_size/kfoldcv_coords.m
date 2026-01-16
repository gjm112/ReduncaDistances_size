%this code runs the first part of k-fold cross-validation 
%This will extract the x,y coordinates obtained by projecting the testing
%and training data into the tangent space of the traning mean.  

%coords_store: nk x 202 table with the coordinates for each curve as a row
%and variables for group and fold 

function [coords] = kfoldcv_coords(data, type_vec, k)
%data: 2xpxn array containing the curves
%type_vec: is an n length vector with the categories we would
%like to classify by  
%k: the number of folds we want 
%% split the data into k groups 

%need to choose some from each category so I will be splitting each
%category into k groups and then combining these

%this gives the number of matrices/curves we have in our dataset
n=size(data,3);

%this gives the number of points we havae on each curve
p=size(data,2);

%this is a vector with the number of matrives/curves we have in each of the
%categories we would like to classify by 
size_cats = groupcounts(type_vec);

%this is the number of categories we have 
n_cats = length(size_cats);

%get the labels of the categories 
tbl = tabulate(type_vec);
names_cats = string(tbl(:,1));

%make a grouping variable that will indicate which group each observation
%is in (so it will have values 1 to k 
grouping = zeros(n,1);

for i=1:n_cats
  %all the possible indexes
  indexes = 1:n;

  %get the indexes (row/col num) of the obs in the ith category 
  cat_index = indexes(type_vec==names_cats(i));
  
  %shuffle them so they are in a random order
  shuffled_cat_index = cat_index(randperm(length(cat_index)));
  
  %initialize a grouping vector for this category
  cat_grouping = zeros(length(cat_index),1);
  
  %amount per group besides last one 
  g_size = ceil(length(cat_index)/k);
  
  %assign groups to shuffled category observations
  for j=1:(k-1)
   cat_grouping((1+(j-1)*g_size):(g_size*j)) = j;
  end
  cat_grouping((1+(k-1)*g_size):length(cat_grouping)) = k;
  
  %assign group to appropriate spot in grouping based in indexes 
  grouping(shuffled_cat_index) = cat_grouping;
end

%% find coordinates using each group as test data set and rest as training

%find the overall mean so we can use it to initialize
mean_overall = FindElasticMeanFast(data);

%storage for the coordinates (k matrices in each)
%coords_store = zeros(n,2*p,k);

%all the possible indexes
indexes = 1:n;

%get the coordinates for the first gold and store in a table with a vector indicator
%what fold and a vector for group

%training data ids
train_ids = indexes(grouping ~= 1); 

%test data ids 
test_ids = indexes(grouping == 1); 

%find the mean of the training data, use overall mean as inital guess 
mean_train = FindElasticMeanFast_intialized(data(:,:,train_ids),mean_overall);

%for each curve in the sample, get the shooting vector from mu to the curve
%register each of these curves to mu and save the coordinates 
for i=1:n
    tmp = ElasticShootingVectorFast(mean_train,data(:,:,i),1);
    %in row i, cols 1 to b, place the x cords of v
    %in row i, cols b+1 to 2*b, place the y cords of v 
    coords(i,1:p) = num2cell(tmp(1,:));
    coords(i,p+1:2*p) = num2cell(tmp(2,:));
end

%make into a table 
coords = array2table(coords);
coords.Properties.VariableNames(1:100) = strcat("X",string(1:100)); 
coords.Properties.VariableNames(101:200) = strcat("Y",string(101:200)); 
coords.fold = ones(n,1);
coords.grouping = grouping;
coords.type = type_vec;
    
% now do the same for the rest of the groups and add them to the table 

for j=2:k
    %all the possible indexes
    indexes = 1:n;
    
    %training data ids
    train_ids = indexes(grouping ~= j); 
    
    %find the mean of the training data, use overall mean as inital guess 
    mean_train = FindElasticMeanFast_intialized(data(:,:,train_ids),mean_overall);
    
    %for each curve in the sample, get the shooting vector from mu to the curve
    %register each of these curves to mu and save the coordinates 
    for i=1:n
        tmp = ElasticShootingVectorFast(mean_train,data(:,:,i),1);
        %in row i, cols 1 to b, place the x cords of v
        %in row i, cols b+1 to 2*b, place the y cords of v 
        coords_store(i,1:p) = num2cell(tmp(1,:));
        coords_store(i,p+1:2*p) = num2cell(tmp(2,:));
    end
    
    %make into a table 
    coords_store = array2table(coords_store);
    coords_store.Properties.VariableNames(1:100) = strcat("X",string(1:100)); 
    coords_store.Properties.VariableNames(101:200) = strcat("Y",string(101:200)); 
    coords_store.fold = j*ones(n,1);
    coords_store.grouping = grouping;
    coords_store.type = type_vec;
    
    %add to coords
    coords = vertcat(coords,coords_store);
    
    clear coords_store;
end

end


