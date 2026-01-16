%random forest algorithm on each fold, fitting it on each
%fold's training data and evaluating how well it predicts on the test data

%coordinates will be obtained by projecting data to the tangent space of
%each category in the training data 

%from each fold, I will save how well the random forest predicted the tribe
%and, when I have all of these I will find the mean and sd of these
%prediction scores 

%TreeBagger creates a bag of decision trees using bootstrapping samples of
%the data and uses a random subset of predictors to use at each decision
%split (ie: random forest algorithm) 

%parameters in TreeBagger 
   % NumTrees: the nummer of bagged classification trees trained using the
   %X: sample data, needs to be a numeric matrix (ie:double)
   %Y: array of response data 

%for each fold, create a bag of decision trees on the train data and save
%how well it does at predicting on the test data 

function  [mean_rf_acc, sd_rf_acc, mean_svm_acc, sd_svm_acc, mean_nn1_acc, sd_nn1_acc, mean_nn3_acc, sd_nn3_acc, mean_nn5_acc, sd_nn5_acc] = kfoldclass_accuracy_nn(data, pd_mat, cat_vec, k, NumTrees)
%data:2xpxn array containing the curves
%cat_vec: is an n length vector with the categories we would like to classify by
%k: number of folds
%NumTrees: Number of tree for random forest

%get which fold each observation is in the test data in
fold_assgn = FoldTestData(cat_vec, k);

%storage for accuracies for rf
accs_rf = NaN(1,k);
accs_svm = NaN(1,k);
accs_nn1 = NaN(1,k);
accs_nn3 = NaN(1,k);
accs_nn5 = NaN(1,k);

%for each fold, fit the algorithms
for i=1:k
   %% Get the coordinates we will use as features 
   %vector with indicators of an obs being in the training data 
   fold_train = (fold_assgn ~= i);
   
   %project all objects onto tangent space of mean of the categories
   %training data and get coords as n x 2*p*m array
   fold_coords = CategoryTrainTangentFeatures(data, cat_vec, fold_train);
   
   %split coords into test and train subset
   fold_test = fold_coords(fold_assgn==i,:);
   fold_train = fold_coords(fold_assgn~=i,:);
   
   %split cat_vec into the test and train subsets for this fold
   cat_vec_test = cat_vec(fold_assgn==i);
   cat_vec_train = cat_vec(fold_assgn~=i);
   
   %% Random Forest 
   
   %fit on training data
   fold_rf_fit = TreeBagger(NumTrees, fold_train, cat_vec_train);
   
   %get predictions for testing data 
   fold_rf_preds = categorical(predict(fold_rf_fit, fold_test));
   
   %get prediction accuracy 
   accs_rf(i) = sum(fold_rf_preds ==  cat_vec_test)/size(fold_rf_preds,1);
   
   %% SVM
   
   %fit on training data
   fold_svm_fit = fitcecoc(fold_train, cat_vec_train);
   
   %get predictions for testing data 
   fold_svm_preds = categorical(predict(fold_svm_fit, fold_test));
   
   %get prediction accuracy 
   accs_svm(i) = sum(fold_svm_preds ==  cat_vec_test)/size(fold_svm_preds,1);
   
   %% NN1
    
	%this gives the number of matrices/curves we have in our dataset
    n=size(cat_vec,1);
   
    %all the possible indexes
    indexes = 1:n;

    %get ids of training and testing data
    train_ids = indexes(folds~=i);
    test_ids = indexes(folds==i);

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

    for l=test_ids
    %extract ids of the ith row of the pairwise distance matrix
    row_l = id_sorted_pd(l,:);

    %this will give me the id of the first train_id that shows up in the row
    %this is the train_id with the shortest distance to this obs in the test
    %dataset
    position_nn = find(row_l.*ismember(row_l,train_ids),1,'first');

    %extract that id 
    nn_id(j) = row_l(position_nn);

    j=j+1;
    end

    %get the type assigned to each obs in the test dataset 
    cat_assgn = cat_vec(nn_id);

    %get the true type of each obs in the test dataset 
    true_cat = cat_vec(test_ids);

    %this gives an array with 1's where the correct type was given 
    correct_vec = cat_assgn == true_cat;

    %what percent of classifications where correct?
    accs_nn1(i) = sum(correct_vec)/size(correct_vec,1);
   
   %% NN3
   
    %for each row for a test data, finds it's three nearest neighbors in the
    %training data 

    %storage
    nn_ids = zeros(size(test_ids,1),3);

    %storage position
    j=1;

    for l=test_ids
        %extract ids of the ith row of the pairwise distance matrix
       row_l = id_sorted_pd(l,:);

       %this will give me the ids of the first 3 train_id that shows up in the row
       %this is the 3 train_ids with the shortest distance to this obs in the test
       %dataset
       position_nn = find(row_l.*ismember(row_l,train_ids),3,'first');

       %extract that id 
       nn_ids(j,:) = row_l(position_nn);

       j=j+1;
    end

    %get the cats assigned to each of the neighbors 
    nn_cats = cat_vec(nn_ids);

    %get the assigned category for each of the test obs
    cat_assgn = string(zeros(length(test_ids),1));

    for b=1:length(test_ids)
        if nn_cats(b,2) == nn_cats(b,3) && nn_cats(b,1) ~= nn_cats(b,2)
            %if 2=3 and 2 ne 1, assign cat 2
            cat_assgn(b) = nn_cats(b,2);
        else 
            %if all the same, 1=2, 1=3, or they are all different, assign cat 1 
            %if none of the categories are equal, assign 1st cat because that
            %is the closest because of how pd_mat is sorted
            cat_assgn(b) = nn_cats(b,1);
        end
    end

    %get the true type of each obs in the test dataset 
    true_cat = string(cat_vec(test_ids));

    %this gives an array with 1's where the correct type was given 
    correct_vec = cat_assgn == true_cat;

    %what percent of classifications where correct?
    accs_nn3(i) = sum(correct_vec)/size(correct_vec,1);
   
   %% NN5
   
    %storage
    nn_ids = zeros(size(test_ids,1),5);

    %storage position
    j=1;

    for l=test_ids
        %extract ids of the ith row of the pairwise distance matrix
       row_l = id_sorted_pd(l,:);

       %this will give me the ids of the first 5 train_id that show up in the row
       %this is the 5 train_ids with the shortest distance to this obs in the test
       %dataset
       position_nn = find(row_l.*ismember(row_l,train_ids),5,'first');

       %extract that id 
       nn_ids(j,:) = row_l(position_nn);

       j=j+1;
    end

    %get the cats assigned to each of the neighbors 
    nn_cats = cat_vec(nn_ids);

    %get the assigned category for each of the test obs
    cat_assgn = string(zeros(length(test_ids),1));

    for b=1:length(test_ids)
        %get table with categories as value and count of each cat as count 
        tab_cats = cell2table(tabulate(nn_cats(b,:)),'VariableNames',{'Value','Count','Percent'});
        tab_cats.Value = string(tab_cats.Value);
        %get the maximum count and it's row in tab_cats 
        [M,I] = max(tab_cats.Count);

        if ismember(M,3:5)==1
            %if max is 3,4, or 5, set cat_assign to the category with that
            %count
            cat_assgn(b) = tab_cats.Value(I);
        elseif M==2
            %if max is 2, assign cat based on if there is one or two pairs
            if sum(tab_cats.Count==2)==1
               %if there is only one pair assign to category with 2 counts
               cat_assgn(b) = tab_cats.Value(I);
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
                   cat_assgn(b) = twice_cats(1);
               else 
                   cat_assgn(b) = twice_cats(2);
               end
            end
        else M==1    
            %assign cat with smallest distance 
            %because of how pd_mat is sorted, this is the cat of the first
            %element in the row
            cat_assgn(b) = nn_cats(b,1);
        end
    end

    %get the true type of each obs in the test dataset 
    true_cat = string(cat_vec(test_ids));

    %this gives an array with 1's where the correct type was given 
    correct_vec = cat_assgn == true_cat;

    %what percent of classifications where correct?
    accs_nn5(i) = sum(correct_vec)/size(correct_vec,1);
end

%% get output 
mean_rf_acc = mean(accs_rf);
sd_rf_acc = std(accs_rf);

mean_svm_acc = mean(accs_svm);
sd_svm_acc = std(accs_svm);

mean_nn1_acc = mean(accs_nn1);
sd_nn1_acc = std(accs_nn1);

mean_nn3_acc = mean(accs_nn3);
sd_nn3_acc = std(accs_nn3);

mean_nn5_acc = mean(accs_nn5);
sd_nn5_acc = std(accs_nn5);

end


