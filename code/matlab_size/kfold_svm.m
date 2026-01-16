%want to use support-vector machines (SVMs) on each fold, fitting it on each
%fold's training data and evaluating how well it predicts on the test data

%we have a multicallss setting, so I believe we should use a multiclass
%error-correcting output (ECOC) model contining SVM binary learners?

function  [mean_accs, sd_accs] = kfold_svm(data, fold_var, group_var, type_var, k, NumCovars)
%data: table with the coordinates for each fold, first 1:NumCovars is the
%covars to bag by and the rest are the other needed variables
%fold_var: name of variable indicating fold
%group_var: name of var indicating grouping within each fold 
%type_var: name of var indicating type (this is what we want to cat. by)
%k: number of folds
%NumCovars: number of covariates to be used

%storage for accuracies
accs = NaN(1,k);

for j=1:k
%subset data
fold = data(table2array(data(:,fold_var))==j,:);
fold_test = fold(table2array(fold(:,group_var))==j,:);
fold_train = fold(table2array(fold(:,group_var))~=j,:);

%fit ensemble on training data
   fold_ecoc = fitcecoc(cell2mat(table2array(fold_train(:,1:NumCovars))), table2array(fold_train(:,type_var)));
   
   %get predictions for testing data 
   fold_predictions = categorical(predict(fold_ecoc, cell2mat(table2array(fold_test(:,1:NumCovars)))));
   
   %get prediction accuracy 
   accs(j) = sum(fold_predictions ==  table2array(fold_test(:,type_var)))/size(fold_predictions,1);
end

mean_accs = mean(accs);
sd_accs = std(accs);
end

