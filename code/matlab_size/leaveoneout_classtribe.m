%% Set-up

%data:2xpxn array containing the curves
%cat_vec: is an n length vector with the categories we would like to classify by
%k: number of folds
%NumTrees: Number of tree for random forest

%set a seed
rng(13434);

%data:2xpxn array containing the curves
data = LM1_teeth; 

%name of tooth
tooth_type = "LM3";

%cat_vec: is an n length vector with the categories we would like to classify by
cat_vec = LM1_ref.tribe; 

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

%matrix with pairwise distances
pd_mat = LM1dmat;
pd_mat_baseline = LM1baselinedmat;

%storage for category assigned by nn indicator
cats_nn1 = NaN(1,n);
cats_nn3 = NaN(1,n);
cats_nn5 = NaN(1,n);
cats_nn1_baseline = NaN(1,n);
cats_nn3_baseline = NaN(1,n);
cats_nn5_baseline = NaN(1,n);

%for each obs, fit the algorithms
for f=1:n
   %% Get the features to use to classify 
   %vector with indicators of an obs being in the training data 
   % obs not assigned to fold 1 are in training data
   index = 1:n;
   train_ind = (index ~= f);
   test_ind = (index ==f);

    %this gives the number of points we havae on each curve
    p=size(data,2);

    %this is the number of categories we have 
    m = length(names_cats);

    %get training data
    train_data = data(:,:,train_ind);
    test_data = data(:,:,(test_ind));
   
   %split cat_vec into the test and train subsets for this fold
   cat_vec_test = cat_vec(index==f);
   cat_vec_train = cat_vec(index~=f);
   
   %% NN1

    %get ids of training and testing data
    train_ids = index(index~=f);
    test_ids = index(index==f);

    %sort each row of the distance matrix
    %save the sorted matrix as sorted_pd and the started indexes of each sorted
    %item as id_sorted_pd
    [sorted_pd,id_sorted_pd] = sort(pd_mat,2);
    [sorted_pd_baseline,id_sorted_pd_baseline] = sort(pd_mat_baseline,2);

    %for each row for a test data, finds it's nearest neighbor in the training
    %data 

    %storage
    nn_id = zeros(size(test_ids,1));
    nn_id_baseline = zeros(size(test_ids,1));

    %storage position
    j=1;
    
    for l=test_ids
    %extract ids of the ith row of the pairwise distance matrix
    row_l = id_sorted_pd(l,:);
    row_l_baseline =  id_sorted_pd_baseline(l,:);

    %this will give me the id of the first train_id that shows up in the row
    %this is the train_id with the shortest distance to this obs in the test
    %dataset
    position_nn = find(row_l.*ismember(row_l,train_ids),1,'first');
    position_nn_baseline = find(row_l_baseline.*ismember(row_l_baseline,train_ids),1,'first');

    %extract that id 
    nn_id(j) = row_l(position_nn);
    nn_id_baseline(j) = row_l(position_nn_baseline);

    j=j+1;
    end

    %get the type assigned to the obs by nn
    cats_nn1(f) = cat_vec(nn_id);
    cats_nn1_baseline(f) = cat_vec(nn_id_baseline);
   
   %% NN3
   
    %for each row for a test data, finds it's three nearest neighbors in the
    %training data 

    %storage
    nn_ids = zeros(size(test_ids,1),3);
    nn_ids_baseline = zeros(size(test_ids,1),3);

    %storage position
    j=1;

    for l=test_ids
        %extract ids of the ith row of the pairwise distance matrix
       row_l = id_sorted_pd(l,:);
       row_l_baseline = id_sorted_pd_baseline(l,:);

       %this will give me the ids of the first 3 train_id that shows up in the row
       %this is the 3 train_ids with the shortest distance to this obs in the test
       %dataset
       position_nn = find(row_l.*ismember(row_l,train_ids),3,'first');
       position_nn_baseline = find(row_l_baseline.*ismember(row_l_baseline,train_ids),3,'first');

       %extract that id 
       nn_ids(j,:) = row_l(position_nn);
       nn_ids_baseline(j,:) = row_l(position_nn_baseline);

       j=j+1;
    end

    %get the cats assigned to each of the neighbors 
    nn_cats = cat_vec(nn_ids);
    nn_cats_baseline = cat_vec(nn_ids_baseline);
    
    %regular 
    if nn_cats(2) == nn_cats(3) && nn_cats(1) ~= nn_cats(2)
        %if 2=3 and 2 ne 1, assign cat 2
        cats_nn3(f) = nn_cats(2);
    else 
        %if all the same, 1=2, 1=3, or they are all different, assign cat 1 
        %if none of the categories are equal, assign 1st cat because that
        %is the closest because of how pd_mat is sorted
        cats_nn3(f) = nn_cats(1);
    end
    
    %for baseline
    if nn_cats_baseline(2) == nn_cats_baseline(3) && nn_cats_baseline(1) ~= nn_cats_baseline(2)
        %if 2=3 and 2 ne 1, assign cat 2
        cats_nn3_baseline(f) = nn_cats_baseline(2);
    else 
        %if all the same, 1=2, 1=3, or they are all different, assign cat 1 
        %if none of the categories are equal, assign 1st cat because that
        %is the closest because of how pd_mat is sorted
        cats_nn3_baseline(f) = nn_cats_baseline(1);
    end
    
    %% NN5
   
    %storage
    nn_ids = zeros(size(test_ids,1),5);
    nn_ids_baseline = zeros(size(test_ids,1),5);

    %storage position
    j=1;

    for l=test_ids
        %extract ids of the ith row of the pairwise distance matrix
       row_l = id_sorted_pd(l,:);
       row_l_baseline = id_sorted_pd_baseline(l,:);

       %this will give me the ids of the first 5 train_id that show up in the row
       %this is the 5 train_ids with the shortest distance to this obs in the test
       %dataset
       position_nn = find(row_l.*ismember(row_l,train_ids),5,'first');
       position_nn_baseline = find(row_l_baseline.*ismember(row_l_baseline,train_ids),5,'first');

       %extract that id 
       nn_ids(j,:) = row_l(position_nn);
       nn_ids_baseline(j,:) = row_l(position_nn_baseline);

       j=j+1;
    end

    %get the cats assigned to each of the neighbors 
    nn_cats = cat_vec(nn_ids);
    nn_cats_baseline = cat_vec(nn_ids_baseline);
    
    %get the assigned category for each of the test obs
    cat_assgn = string(zeros(length(test_ids),1));
    cat_assgn_baseline = string(zeros(length(test_ids),1));

    for b=1:length(test_ids)
        %get table with categories as value and count of each cat as count 
        tab_cats = cell2table(tabulate(nn_cats(b,:)),'VariableNames',{'Value','Count','Percent'});
        tab_cats.Value = string(tab_cats.Value);
        %get the maximum count and it's row in tab_cats 
        [M,I] = max(tab_cats.Count);

        if ismember(M,3:5)==1
            %if max is 3,4, or 5, set cat_assign to the category with that
            %count
            cats_nn5(f) = tab_cats.Value(I);
        elseif M==2
            %if max is 2, assign cat based on if there is one or two pairs
            if sum(tab_cats.Count==2)==1
               %if there is only one pair assign to category with 2 counts
               cats_nn5(f) = tab_cats.Value(I);
            else
               %if there is two pairs, take the average distance of both pairs and assign
               %cat with smallest average 
               %because of how pd_mat is sorted, and thus nn_cats, this will be
               %the category with the smallest average position in nn_cats

               %extract the categories that occur twice
               twice_cats = tab_cats.Value(tab_cats.Count==2,:);

               %get the mean id of both categories that occur twice
               meanid_cat1 = mean(find(ismember(nn_cats(b,:), twice_cats(1)))); 
               meanid_cat2 = mean(find(ismember(nn_cats(b,:), twice_cats(2))));

               %assign cat with smallest mean id
               if meanid_cat1 < meanid_cat2
                   cats_nn5(f) = twice_cats(1);
               else 
                   cats_nn5(f) = twice_cats(2);
               end
            end
        else M==1    
            %assign cat with smallest distance 
            %because of how pd_mat is sorted, this is the cat of the first
            %element in the row
            cats_nn5(f) = nn_cats(b,1);
        end
    end
    
    for b=1:length(test_ids)
        %get table with categories as value and count of each cat as count 
        tab_cats = cell2table(tabulate(nn_cats_baseline(b,:)),'VariableNames',{'Value','Count','Percent'});
        tab_cats.Value = string(tab_cats.Value);
        %get the maximum count and it's row in tab_cats 
        [M,I] = max(tab_cats.Count);

        if ismember(M,3:5)==1
            %if max is 3,4, or 5, set cat_assign to the category with that
            %count
            cats_nn5_baseline(f) = tab_cats.Value(I);
        elseif M==2
            %if max is 2, assign cat based on if there is one or two pairs
            if sum(tab_cats.Count==2)==1
               %if there is only one pair assign to category with 2 counts
               cats_nn5_baseline(f) = tab_cats.Value(I);
            else
               %if there is two pairs, take the average distance of both pairs and assign
               %cat with smallest average 
               %because of how pd_mat is sorted, and thus nn_cats, this will be
               %the category with the smallest average position in nn_cats

               %extract the categories that occur twice
               twice_cats = tab_cats.Value(tab_cats.Count==2,:);

               %get the mean id of both categories that occur twice
               meanid_cat1 = mean(find(ismember(nn_cats_baseline(b,:), twice_cats(1)))); 
               meanid_cat2 = mean(find(ismember(nn_cats_baseline(b,:), twice_cats(2))));

               %assign cat with smallest mean id
               if meanid_cat1 < meanid_cat2
                   cats_nn5_baseline(f) = twice_cats(1);
               else 
                   cats_nn5_baseline(f) = twice_cats(2);
               end
            end
        else M==1    
            %assign cat with smallest distance 
            %because of how pd_mat is sorted, this is the cat of the first
            %element in the row
            cats_nn5_baseline(f) = nn_cats_baseline(b,1);
        end
    end
end

%get vector of categories as numeric 
[~,~,cat_vecnum] = unique(cat_vec);

%vector which indicates if curves were classified correctly 
correct_nn1 = cats_nn1 == cat_vecnum.';
correct_nn3 = cats_nn3 == cat_vecnum.';
correct_nn5 = cats_nn5 == cat_vecnum.';
correct_nn1_baseline = cats_nn1_baseline == cat_vecnum.';
correct_nn3_baseline = cats_nn3_baseline == cat_vecnum.';
correct_nn5_baseline = cats_nn5_baseline == cat_vecnum.';

%overall accruacy
overallnn1_acc = sum(correct_nn1)/length(correct_nn1);
overallnn3_acc = sum(correct_nn3)/length(correct_nn3);
overallnn5_acc = sum(correct_nn5)/length(correct_nn5);
overallnn1_baseline_acc = sum(correct_nn1_baseline)/length(correct_nn1_baseline);
overallnn3_baseline_acc = sum(correct_nn3_baseline)/length(correct_nn3_baseline);
overallnn5_baseline_acc = sum(correct_nn5_baseline)/length(correct_nn5_baseline);

%within tribe accuracies 

catnn1_accs = NaN(1,n_cats);
catnn3_accs = NaN(1,n_cats);
catnn5_accs = NaN(1,n_cats);
catnn1_baseline_accs = NaN(1,n_cats);
catnn3_baseline_accs = NaN(1,n_cats);
catnn5_baseline_accs = NaN(1,n_cats);

for c=1:n_cats
    %nn1 
    catcorrect_nn1 = (cats_nn1(cat_vecnum==c) == cat_vecnum(cat_vecnum==c).');
    catnn1_accs(c) = sum(catcorrect_nn1)/length(catcorrect_nn1);
    %nn3 
    catcorrect_nn3 = (cats_nn3(cat_vecnum==c) == cat_vecnum(cat_vecnum==c).');
    catnn3_accs(c) = sum(catcorrect_nn3)/length(catcorrect_nn3);
    %nn5
    catcorrect_nn5 = (cats_nn5(cat_vecnum==c) == cat_vecnum(cat_vecnum==c).');
    catnn5_accs(c) = sum(catcorrect_nn5)/length(catcorrect_nn5);
    %nn1 baseline
    catcorrect_nn1_baseline = (cats_nn1_baseline(cat_vecnum==c) == cat_vecnum(cat_vecnum==c).');
    catnn1_baseline_accs(c) = sum(catcorrect_nn1_baseline)/length(catcorrect_nn1_baseline);
    %nn3 baseline
    catcorrect_nn3_baseline = (cats_nn3_baseline(cat_vecnum==c) == cat_vecnum(cat_vecnum==c).');
    catnn3_baseline_accs(c) = sum(catcorrect_nn3_baseline)/length(catcorrect_nn3_baseline);
    %nn5 baselin
    catcorrect_nn5_baseline = (cats_nn5_baseline(cat_vecnum==c) == cat_vecnum(cat_vecnum==c).');
    catnn5_baseline_accs(c) = sum(catcorrect_nn5_baseline)/length(catcorrect_nn5_baseline);    
end    

%output 