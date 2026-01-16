%This code runs k=5 nearest neighbor classification on pairwise
%distance matrices 

%this one classifies based on its three nearest neighbors based on the
%following rules:
% 1) assign the cat that has the most occurances in the three nns
% 2) if the three nns have three diff. cats, assign the category of the 
% closest neighbor 

%outputs:
% perc_correct: the percent correctly categorized
% cat_assgn: the category assigned to each obs in test by algorithm
% test_ids: the ids of each of the obs in the test dataset 

function [perc_correct, cat_assgn, test_ids] = NearestNeighbor5_Class(pd_mat, type_vec, train_props)

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

%for each row for a test data, finds it's five nearest neighbors in the
%training data 

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
nn_cats = type_vec(nn_ids);

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
true_cat = string(type_vec(test_ids));

%this gives an array with 1's where the correct type was given 
correct_vec = cat_assgn == true_cat;

%what percent of classifications where correct?
perc_correct = sum(correct_vec)/size(correct_vec,1);
end
