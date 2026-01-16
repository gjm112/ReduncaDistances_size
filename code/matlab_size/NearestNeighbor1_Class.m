%This code runs k=1 nearest neighbor classification on pairwise
%distance matrices 

%this one classifies to the single closest neighbor 

%outputs:
% perc_correct: the percent correctly categorized
% cat_assgn: the category assigned to each obs in test by algorithm
% test_ids: the ids of each of the obs in the test dataset 

function [perc_correct, cat_assgn, test_ids] = NearestNeighbor1_Class(pd_mat, type_vec, train_props)

%pd_mat is aan n x n symmatric matrix of distances with 0s on the diagonal.
%This matrix should include both test and training data

%type_vec: is an n length vector with the categories we would
%like to classify by  

%train_props is the proportion of each tribe in the training
%data 

%this gives the number of matrices/curves we have in our dataset
n=size(pd_mat,1);

%this is a vector with the number of matrives/curves we have in each of the
%categories we would like to classify by 
size_cats = groupcounts(type_vec);

%this is the number of categories we have 
n_cats = length(size_cats);

%get the labels of the categories 
tbl = tabulate(type_vec);
names_cats = string(tbl(:,1));

%ids for train and test data
%choose random set of ids as train and make the rest test
%do this within each tribe to ensure that we get some from each 
train_ids = [];
test_ids=[];
for i=1:n_cats
  %all the possible indexes
  indexes = 1:n;

  %get the indexes (row/col num) of the obs in the ith category 
  cat_index = indexes(type_vec==names_cats(i));
  
  %get training and testing indexes for cat i 
  itrain_ids = cat_index(randperm(size_cats(i),ceil(size_cats(i)*train_props)));
  itest_ids = setdiff(cat_index,itrain_ids);  
  
  %conctenate indexs into one vector
  train_ids = [train_ids itrain_ids];
  test_ids = [test_ids itest_ids];
end 

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
cat_assgn = type_vec(nn_id);

%get the true type of each obs in the test dataset 
true_cat = type_vec(test_ids);

%this gives an array with 1's where the correct type was given 
correct_vec = cat_assgn == true_cat;

%what percent of classifications where correct?
perc_correct = sum(correct_vec)/size(correct_vec,1);

end

