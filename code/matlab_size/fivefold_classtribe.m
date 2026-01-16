%% Set-up

%data:2xpxn array containing the curves
%cat_vec: is an n length vector with the categories we would like to classify by
%k: number of folds
%NumTrees: Number of tree for random forest

%set a seed
rng(13434);

%data:2xpxn array containing the curves
data = UM3_teeth; 

%name of tooth
tooth_type = "UM3";

%cat_vec: is an n length vector with the categories we would like to classify by
cat_vec = UM3_ref.tribe; 
writematrix(cat_vec,strcat(tooth_type,"cat_vec.csv"));

%k: number of folds
k=5;

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

%Number of trees for random forest
NumTrees = 50; 

%matrix with pairwise distances
pd_mat = UM3dmat;
pd_mat_baseline = UM3baselinedmat;

%get which fold each observation is in the test data in
folds = FoldTestData(cat_vec, k);
writematrix(folds,strcat(tooth_type,"folds.csv"));

%storage for accuracies for rf
accs_rf = NaN(1,k);
accs_svm = NaN(1,k);
accs_PCrf = NaN(1,k);
accs_PCsvm = NaN(1,k);
accs_rf_overall = NaN(1,k);
accs_svm_overall = NaN(1,k);
accs_PCrf_overall = NaN(1,k);
accs_PCsvm_overall = NaN(1,k);
accs_nn1 = NaN(1,k);
accs_nn3 = NaN(1,k);
accs_nn5 = NaN(1,k);
accs_nn1_baseline = NaN(1,k);
accs_nn3_baseline = NaN(1,k);
accs_nn5_baseline = NaN(1,k);

%for each fold, fit the algorithms
for f=1:k
   %% Get the features to use to classify 
   %vector with indicators of an obs being in the training data 
   % obs not assigned to fold 1 are in training data
   train_ind = (folds ~= f);
   test_ind = (folds ==f);

    %this gives the number of points we havae on each curve
    p=size(data,2);

    %this is the number of categories we have 
    m = length(names_cats);

    %get training data
    train_data = data(:,:,train_ind);
    test_data = data(:,:,(test_ind));

    %this puts each of the curves into SRVF form 
    %figure(1); clf; 
    for j=1:n
        X = ReSampleCurve(data(:,:,j),100);
        q(:,:,j) = curve_to_q(X);
    end
    train_q = q(:,:,train_ind);
    test_q = q(:,:,test_ind);

   [fold_test, fold_train, fold_PCtest, fold_PCtrain, fold_test_overall, fold_train_overall, fold_PCtest_overall, fold_PCtrain_overall] = TrainTestFeatures(data, cat_vec, train_ind, test_ind);
  
   %write each set of features to a csv file names appropriately to reflect
   %the fold number 
   writematrix(fold_test, strcat(tooth_type,"fold_test", string(f), ".csv"))
   writematrix(fold_train, strcat(tooth_type,"fold_train", string(f), ".csv"))
   writematrix(fold_PCtest, strcat(tooth_type,"fold_PCtest", string(f), ".csv"))
   writematrix(fold_PCtrain, strcat(tooth_type,"fold_PCtrain", string(f), ".csv"))
   writematrix(fold_test_overall, strcat(tooth_type,"fold_test_overall", string(f), ".csv"))
   writematrix(fold_train_overall, strcat(tooth_type,"fold_train_overall", string(f), ".csv"))
   writematrix(fold_PCtest_overall, strcat(tooth_type,"fold_PCtest_overall", string(f), ".csv"))
   writematrix(fold_PCtrain_overall, strcat(tooth_type,"fold_PCtrain_overall", string(f), ".csv"))
   
   %split cat_vec into the test and train subsets for this fold
   cat_vec_test = cat_vec(folds==f);
   cat_vec_train = cat_vec(folds~=f);
   
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
    accs_rf(f) = sum(fold_rf_preds ==  cat_vec_test)/size(fold_rf_preds,1);
    accs_rf_overall(f) = sum(fold_rf_preds_overall ==  cat_vec_test)/size(fold_rf_preds_overall,1);
    accs_PCrf(f) = sum(fold_PCrf_preds ==  cat_vec_test)/size(fold_PCrf_preds,1);
    accs_PCrf_overall(f) = sum(fold_PCrf_preds_overall ==  cat_vec_test)/size(fold_PCrf_preds_overall,1);

    %% Classification with SVM 

    %fit on training data
    fold_svm_fit = fitcecoc(fold_train, cat_vec_train);
    fold_svm_fit_overall = fitcecoc(fold_train_overall, cat_vec_train);
    fold_PCsvm_fit = fitcecoc(fold_PCtrain, cat_vec_train);
    fold_PCsvm_fit_overall = fitcecoc(fold_PCtrain_overall, cat_vec_train);

    %get predictions for testing data 
    fold_svm_preds = categorical(predict(fold_svm_fit, fold_test));
    fold_svm_preds_overall = categorical(predict(fold_svm_fit_overall, fold_test_overall));
    fold_PCsvm_preds = categorical(predict(fold_PCsvm_fit, fold_PCtest));
    fold_PCsvm_preds_overall = categorical(predict(fold_PCsvm_fit_overall, fold_PCtest_overall));

    %get prediction accuracy 
    accs_svm(f) = sum(fold_svm_preds ==  cat_vec_test)/size(fold_svm_preds,1);
    accs_svm_overall(f) = sum(fold_svm_preds_overall ==  cat_vec_test)/size(fold_svm_preds_overall,1);
    accs_PCsvm(f) = sum(fold_PCsvm_preds ==  cat_vec_test)/size(fold_PCsvm_preds,1);
    accs_PCsvm_overall(f) = sum(fold_PCsvm_preds_overall ==  cat_vec_test)/size(fold_PCsvm_preds_overall,1);
   
 %% NN1
   
	%this gives the number of matrices/curves we have in our dataset
    n=size(cat_vec,1);
   
    %all the possible indexes
    indexes = 1:n;

    %get ids of training and testing data
    train_ids = indexes(folds~=f);
    test_ids = indexes(folds==f);

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

    %get the type assigned to each obs in the test dataset 
    cat_assgn = cat_vec(nn_id);
    cat_assgn_baseline = cat_vec(nn_id_baseline);

    %get the true type of each obs in the test dataset 
    true_cat = cat_vec(test_ids);

    %this gives an array with 1's where the correct type was given 
    correct_vec = cat_assgn == true_cat;
    correct_vec_baseline = cat_assgn_baseline == true_cat;

    %what percent of classifications where correct?
    accs_nn1(f) = sum(correct_vec)/size(correct_vec,1);
    accs_nn1_baseline(f) = sum(correct_vec_baseline)/size(correct_vec_baseline,1);
   
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

    %get the assigned category for each of the test obs
    cat_assgn = string(zeros(length(test_ids),1));
    cat_assgn_baseline = string(zeros(length(test_ids),1));

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
    
    for b=1:length(test_ids)
        if nn_cats_baseline(b,2) == nn_cats_baseline(b,3) && nn_cats_baseline(b,1) ~= nn_cats_baseline(b,2)
            %if 2=3 and 2 ne 1, assign cat 2
            cat_assgn_baseline(b) = nn_cats_baseline(b,2);
        else 
            %if all the same, 1=2, 1=3, or they are all different, assign cat 1 
            %if none of the categories are equal, assign 1st cat because that
            %is the closest because of how pd_mat is sorted
            cat_assgn_baseline(b) = nn_cats_baseline(b,1);
        end
    end

    %get the true type of each obs in the test dataset 
    true_cat = string(cat_vec(test_ids));

    %this gives an array with 1's where the correct type was given 
    correct_vec = cat_assgn == true_cat;
    correct_vec_baseline = cat_assgn_baseline == true_cat;

    %what percent of classifications where correct?
    accs_nn3(f) = sum(correct_vec)/size(correct_vec,1);
    accs_nn3_baseline(f) = sum(correct_vec_baseline)/size(correct_vec_baseline,1);
   
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
    
    for b=1:length(test_ids)
        %get table with categories as value and count of each cat as count 
        tab_cats = cell2table(tabulate(nn_cats_baseline(b,:)),'VariableNames',{'Value','Count','Percent'});
        tab_cats.Value = string(tab_cats.Value);
        %get the maximum count and it's row in tab_cats 
        [M,I] = max(tab_cats.Count);

        if ismember(M,3:5)==1
            %if max is 3,4, or 5, set cat_assign to the category with that
            %count
            cat_assgn_baseline(b) = tab_cats.Value(I);
        elseif M==2
            %if max is 2, assign cat based on if there is one or two pairs
            if sum(tab_cats.Count==2)==1
               %if there is only one pair assign to category with 2 counts
               cat_assgn_baseline(b) = tab_cats.Value(I);
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
                   cat_assgn_baseline(b) = twice_cats(1);
               else 
                   cat_assgn_baseline(b) = twice_cats(2);
               end
            end
        else M==1    
            %assign cat with smallest distance 
            %because of how pd_mat is sorted, this is the cat of the first
            %element in the row
            cat_assgn_baseline(b) = nn_cats_baseline(b,1);
        end
    end

    %get the true type of each obs in the test dataset 
    true_cat = string(cat_vec(test_ids));

    %this gives an array with 1's where the correct type was given 
    correct_vec = cat_assgn == true_cat;
    correct_vec_baseline = cat_assgn_baseline == true_cat;

    %what percent of classifications where correct?
    accs_nn5(f) = sum(correct_vec)/size(correct_vec,1);
    accs_nn5_baseline(f) = sum(correct_vec_baseline)/size(correct_vec_baseline,1);
end

%% get output 
mean_rf_acc = mean(accs_rf);
sd_rf_acc = std(accs_rf);
mean_rf_acc_overall = mean(accs_rf_overall);
sd_rf_acc_overall = std(accs_rf_overall);
mean_PCrf_acc = mean(accs_PCrf);
sd_PCrf_acc = std(accs_PCrf);
mean_PCrf_acc_overall = mean(accs_PCrf_overall);
sd_PCrf_acc_overall = std(accs_PCrf_overall);

mean_svm_acc = mean(accs_svm);
sd_svm_acc = std(accs_svm);
mean_svm_acc_overall = mean(accs_svm_overall);
sd_svm_acc_overall = std(accs_svm_overall);
mean_PCsvm_acc = mean(accs_PCsvm);
sd_PCsvm_acc = std(accs_PCsvm);
mean_PCsvm_acc_overall = mean(accs_PCsvm_overall);
sd_PCsvm_acc_overall = std(accs_PCsvm_overall);

mean_nn1_acc = mean(accs_nn1);
sd_nn1_acc = std(accs_nn1);
mean_nn1_baseline_acc = mean(accs_nn1_baseline);
sd_nn1_baseline_acc = std(accs_nn1_baseline);

mean_nn3_acc = mean(accs_nn3);
sd_nn3_acc = std(accs_nn3);
mean_nn3_baseline_acc = mean(accs_nn3_baseline);
sd_nn3_baseline_acc = std(accs_nn3_baseline);

mean_nn5_acc = mean(accs_nn5);
sd_nn5_acc = std(accs_nn5);
mean_nn5_baseline_acc = mean(accs_nn5_baseline);
sd_nn5_baseline_acc = std(accs_nn5_baseline);

class_type = ["rf"; "rf_overall";"PCrf"; "PCrf_overall"; "svm"; "svm_overall";"PCsvm"; "PCsvm_overall"; "nn1";"nn3";"nn5"; "nn1_baseline";"nn3_baseline";"nn5_baseline"];
means = [mean_rf_acc; mean_rf_acc_overall; mean_PCrf_acc; mean_PCrf_acc_overall; mean_svm_acc; mean_svm_acc_overall; mean_PCsvm_acc; mean_PCsvm_acc_overall; mean_nn1_acc; mean_nn3_acc;mean_nn5_acc; mean_nn1_baseline_acc; mean_nn3_baseline_acc;mean_nn5_baseline_acc];
sds = [sd_rf_acc; sd_rf_acc_overall; sd_PCrf_acc; sd_PCrf_acc_overall; sd_svm_acc; sd_svm_acc_overall; sd_PCsvm_acc; sd_PCsvm_acc_overall; sd_nn1_acc; sd_nn3_acc;sd_nn5_acc;sd_nn1_baseline_acc; sd_nn3_baseline_acc;sd_nn5_baseline_acc];

output = table(class_type, means, sds);

writetable(output,'UM3_5foldclass_results.csv')