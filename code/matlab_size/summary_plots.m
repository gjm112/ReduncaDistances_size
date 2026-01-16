%summary plots

%% Set-up 
mean = UM3_Tra_mean;
mean_q = UM3_Tra_mean_q;
median = UM3_Tra_med;

FindElasticCovarianceFast(mean,mean_q);

%% Mean 

figure('Name', 'Mean'); clf; 
mean_p = q_to_curve(mean);
plot(mean_p(1,:),mean_p(2,:),'LineWidth',3);
axis equal;

%% Median 

figure('Name','Median'); clf; 
median_p = q_to_curve(median);
plot(median_p(1,:),median_p(2,:),'LineWidth',3);
axis equal;

%% PCs from -1.5 to +1.5 SDs and Random Sample from Gaussian 

FindElasticCovarianceFast(mean,mean_q);

%% PCA Plots 
PCA_plots(mean,mean_q)
