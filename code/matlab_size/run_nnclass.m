%this script is going to run k nearest neighbors classification num_reps times under
%different with varied proportions of training data and report the average
%accuracy and it's empirical se for each setting considered

%consider k=1,3,5

function results_tab = run_nnclass(pd_mat,type_vec, num_reps) 
%set a seed
rng(13448);

%storage 
perc_k1_t50 = NaN(1,num_reps);
perc_k3_t50 = NaN(1,num_reps);
perc_k5_t50 = NaN(1,num_reps);
perc_k1_t67 = NaN(1,num_reps);
perc_k3_t67 = NaN(1,num_reps);
perc_k5_t67 = NaN(1,num_reps);
perc_k1_t80 = NaN(1,num_reps);
perc_k3_t80 = NaN(1,num_reps);
perc_k5_t80 = NaN(1,num_reps);

for rep=1:num_reps
    
    %run 1-NN under each training prop
    perc_k1_t50(rep) = NearestNeighbor1_Class(pd_mat, type_vec, 0.5);
    perc_k1_t67(rep) = NearestNeighbor1_Class(pd_mat, type_vec, 2/3);
    perc_k1_t80(rep) = NearestNeighbor1_Class(pd_mat, type_vec, 0.8);
    
    %run 3-NN under each training prop
    perc_k3_t50(rep) = NearestNeighbor3_Class(pd_mat, type_vec, 0.5);
    perc_k3_t67(rep) = NearestNeighbor3_Class(pd_mat, type_vec, 2/3);
    perc_k3_t80(rep) = NearestNeighbor3_Class(pd_mat, type_vec, 0.8);
    
    %run 1-NN under each training prop
    perc_k5_t50(rep) = NearestNeighbor5_Class(pd_mat, type_vec, 0.5);
    perc_k5_t67(rep) = NearestNeighbor5_Class(pd_mat, type_vec, 2/3);
    perc_k5_t80(rep) = NearestNeighbor5_Class(pd_mat, type_vec, 0.8);
    
    rep
end

%get average and se for each setting we tried
avg_perc_k1_t50 = mean(perc_k1_t50);
se_perc_k1_t50 = std(perc_k1_t50);
avg_perc_k1_t67 = mean(perc_k1_t67);
se_perc_k1_t67= std(perc_k1_t67);
avg_perc_k1_t80 = mean(perc_k1_t80);
se_perc_k1_t80 = std(perc_k1_t80);

avg_perc_k3_t50 = mean(perc_k3_t50);
se_perc_k3_t50 = std(perc_k3_t50);
avg_perc_k3_t67 = mean(perc_k3_t67);
se_perc_k3_t67= std(perc_k3_t67);
avg_perc_k3_t80 = mean(perc_k3_t80);
se_perc_k3_t80 = std(perc_k3_t80);


avg_perc_k5_t50 = mean(perc_k5_t50);
se_perc_k5_t50 = std(perc_k5_t50);
avg_perc_k5_t67 = mean(perc_k5_t67);
se_perc_k5_t67= std(perc_k5_t67);
avg_perc_k5_t80 = mean(perc_k5_t80);
se_perc_k5_t80 = std(perc_k5_t80);

%make into a table 
k = [1,1,1,3,3,3,5,5,5]';
train_prop = [50,67,80,50,67,80,50,67,80]';
avg = [avg_perc_k1_t50, avg_perc_k1_t67,avg_perc_k1_t80,avg_perc_k3_t50, avg_perc_k3_t67,avg_perc_k3_t80,avg_perc_k5_t50,avg_perc_k5_t67,avg_perc_k5_t80]';
se = [se_perc_k1_t50, se_perc_k1_t67,se_perc_k1_t80,se_perc_k3_t50, se_perc_k3_t67,se_perc_k3_t80,se_perc_k5_t50,se_perc_k5_t67,se_perc_k5_t80]';

results_tab = table(k,train_prop, avg,se);

end
