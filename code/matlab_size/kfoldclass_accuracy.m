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

function  [mean_rf_acc, sd_rf_acc, mean_svm_acc, sd_svm_acc] = kfoldclass_accuracy(data, cat_vec, k, NumTrees)
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
   
end

%% get output 
mean_rf_acc = mean(accs_rf);
sd_rf_acc = std(accs_rf);

mean_svm_acc = mean(accs_svm);
sd_svm_acc = std(accs_svm);
end







