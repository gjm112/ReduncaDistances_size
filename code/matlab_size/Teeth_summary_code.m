%use this code to get summaries of the teeth of tribes, split by tribe

%get the mean, plus the plots
%[LM3_Alc_mean, LM3_Alc_mean_q, LM3_Alc_mean_E] = FindElasticMeanFast(LM3_Alc_teeth)
%c[LM3_Ant_mean, LM3_Ant_mean_q, LM3_Ant_mean_E] = FindElasticMeanFast(LM3_Ant_teeth) 
[LM3_Bov_mean, LM3_Bov_mean_q, LM3_Bov_mean_E] = FindElasticMeanFast(LM3_Bov_teeth) 
[LM3_Hip_mean, LM3_Hip_mean_q, LM3_Hip_mean_E] = FindElasticMeanFast(LM3_Hip_teeth) 
[LM3_Neo_mean, LM3_Neo_mean_q, LM3_Neo_mean_E] = FindElasticMeanFast(LM3_Neo_teeth) 
[LM3_Red_mean, LM3_Red_mean_q, LM3_Red_mean_E] = FindElasticMeanFast(LM3_Red_teeth) 
[LM3_Tra_mean, LM3_Tra_mean_q, LM3_Tra_mean_E] = FindElasticMeanFast(LM3_Tra_teeth) 

%get the median, plus the plots
[LM3_Alc_med, LM3_Alc_med_q, LM3_Alc_med_E] = FindElasticMedianFast(LM3_Alc_teeth) 
[LM3_Ant_med, LM3_Ant_med_q, LM3_Ant_med_E] = FindElasticMedianFast(LM3_Ant_teeth) 
[LM3_Bov_med, LM3_Bov_med_q, LM3_Bov_med_E] = FindElasticMedianFast(LM3_Bov_teeth) 
[LM3_Hip_med, LM3_Hip_med_q, LM3_Hip_med_E] = FindElasticMedianFast(LM3_Hip_teeth) 
[LM3_Neo_med, LM3_Neo_med_q, LM3_Neo_med_E] = FindElasticMedianFast(LM3_Neo_teeth) 
[LM3_Red_med, LM3_Red_med_q, LM3_Red_med_E] = FindElasticMedianFast(LM3_Red_teeth) 
[LM3_Tra_med, LM3_Tra_med_q, LM3_Tra_med_E] = FindElasticMedianFast(LM3_Tra_teeth) 

%get the elastic covariance (around the median), plus some of the plots 
LM3_Alc_Cov = FindElasticCovarianceFast(LM3_Alc_mean, LM3_Alc_mean_q)
LM3_Ant_Cov = FindElasticCovarianceFast(LM3_Ant_mean, LM3_Ant_mean_q)
LM3_Bov_Cov = FindElasticCovarianceFast(LM3_Bov_mean, LM3_Bov_mean_q)
LM3_Hip_Cov = FindElasticCovarianceFast(LM3_Hip_mean, LM3_Hip_mean_q)
LM3_Neo_Cov = FindElasticCovarianceFast(LM3_Neo_mean, LM3_Neo_mean_q)
LM3_Red_Cov = FindElasticCovarianceFast(LM3_Red_mean, LM3_Red_mean_q)
LM3_Tra_Cov = FindElasticCovarianceFast(LM3_Tra_mean, LM3_Tra_mean_q)

%saving it 
save('LM3_Alc_Sums.mat', 'LM3_Alc_mean', 'LM3_Alc_mean_E','LM3_Alc_mean_q', 'LM3_Alc_med','LM3_Alc_med_E', 'LM3_Alc_med_q','LM3_Alc_Cov')
save('LM3_Ant_Sums.mat', 'LM3_Ant_mean', 'LM3_Ant_mean_E','LM3_Ant_mean_q', 'LM3_Ant_med','LM3_Ant_med_E', 'LM3_Ant_med_q','LM3_Ant_Cov')
save('LM3_Bov_Sums.mat', 'LM3_Bov_mean', 'LM3_Bov_mean_E','LM3_Bov_mean_q', 'LM3_Bov_med','LM3_Bov_med_E', 'LM3_Bov_med_q','LM3_Bov_Cov')
save('LM3_Hip_Sums.mat', 'LM3_Hip_mean', 'LM3_Hip_mean_E','LM3_Hip_mean_q', 'LM3_Hip_med','LM3_Hip_med_E', 'LM3_Hip_med_q','LM3_Hip_Cov')
save('LM3_Neo_Sums.mat', 'LM3_Neo_mean', 'LM3_Neo_mean_E','LM3_Neo_mean_q', 'LM3_Neo_med','LM3_Neo_med_E', 'LM3_Neo_med_q','LM3_Neo_Cov')
save('LM3_Red_Sums.mat', 'LM3_Red_mean', 'LM3_Red_mean_E','LM3_Red_mean_q', 'LM3_Red_med','LM3_Red_med_E', 'LM3_Red_med_q','LM3_Red_Cov')
save('LM3_Tra_Sums.mat', 'LM3_Tra_mean', 'LM3_Tra_mean_E','LM3_Tra_mean_q', 'LM3_Tra_med','LM3_Tra_med_E', 'LM3_Tra_med_q','LM3_Tra_Cov')

%get the mean, plus the plots
[UM1_Alc_mean, UM1_Alc_mean_q, UM1_Alc_mean_E] = FindElasticMeanFast(UM1_Alc_teeth)
[UM1_Ant_mean, UM1_Ant_mean_q, UM1_Ant_mean_E] = FindElasticMeanFast(UM1_Ant_teeth) 
[UM1_Bov_mean, UM1_Bov_mean_q, UM1_Bov_mean_E] = FindElasticMeanFast(UM1_Bov_teeth) 
[UM1_Hip_mean, UM1_Hip_mean_q, UM1_Hip_mean_E] = FindElasticMeanFast(UM1_Hip_teeth) 
[UM1_Neo_mean, UM1_Neo_mean_q, UM1_Neo_mean_E] = FindElasticMeanFast(UM1_Neo_teeth) 
[UM1_Red_mean, UM1_Red_mean_q, UM1_Red_mean_E] = FindElasticMeanFast(UM1_Red_teeth) 
[UM1_Tra_mean, UM1_Tra_mean_q, UM1_Tra_mean_E] = FindElasticMeanFast(UM1_Tra_teeth) 

%get the median, plus the plots
[UM1_Alc_med, UM1_Alc_med_q, UM1_Alc_med_E] = FindElasticMedianFast(UM1_Alc_teeth) 
[UM1_Ant_med, UM1_Ant_med_q, UM1_Ant_med_E] = FindElasticMedianFast(UM1_Ant_teeth) 
[UM1_Bov_med, UM1_Bov_med_q, UM1_Bov_med_E] = FindElasticMedianFast(UM1_Bov_teeth) 
[UM1_Hip_med, UM1_Hip_med_q, UM1_Hip_med_E] = FindElasticMedianFast(UM1_Hip_teeth) 
[UM1_Neo_med, UM1_Neo_med_q, UM1_Neo_med_E] = FindElasticMedianFast(UM1_Neo_teeth) 
[UM1_Red_med, UM1_Red_med_q, UM1_Red_med_E] = FindElasticMedianFast(UM1_Red_teeth) 
[UM1_Tra_med, UM1_Tra_med_q, UM1_Tra_med_E] = FindElasticMedianFast(UM1_Tra_teeth) 

%get the elastic covariance (around the median), plus some of the plots 
UM1_Alc_Cov = FindElasticCovarianceFast(UM1_Alc_mean, UM1_Alc_mean_q)
UM1_Ant_Cov = FindElasticCovarianceFast(UM1_Ant_mean, UM1_Ant_mean_q)
UM1_Bov_Cov = FindElasticCovarianceFast(UM1_Bov_mean, UM1_Bov_mean_q)
UM1_Hip_Cov = FindElasticCovarianceFast(UM1_Hip_mean, UM1_Hip_mean_q)
UM1_Neo_Cov = FindElasticCovarianceFast(UM1_Neo_mean, UM1_Neo_mean_q)
UM1_Red_Cov = FindElasticCovarianceFast(UM1_Red_mean, UM1_Red_mean_q)
UM1_Tra_Cov = FindElasticCovarianceFast(UM1_Tra_mean, UM1_Tra_mean_q)

%saving it 
save('UM1_Alc_Sums.mat', 'UM1_Alc_mean', 'UM1_Alc_mean_E','UM1_Alc_mean_q', 'UM1_Alc_med','UM1_Alc_med_E', 'UM1_Alc_med_q','UM1_Alc_Cov')
save('UM1_Ant_Sums.mat', 'UM1_Ant_mean', 'UM1_Ant_mean_E','UM1_Ant_mean_q', 'UM1_Ant_med','UM1_Ant_med_E', 'UM1_Ant_med_q','UM1_Ant_Cov')
save('UM1_Bov_Sums.mat', 'UM1_Bov_mean', 'UM1_Bov_mean_E','UM1_Bov_mean_q', 'UM1_Bov_med','UM1_Bov_med_E', 'UM1_Bov_med_q','UM1_Bov_Cov')
save('UM1_Hip_Sums.mat', 'UM1_Hip_mean', 'UM1_Hip_mean_E','UM1_Hip_mean_q', 'UM1_Hip_med','UM1_Hip_med_E', 'UM1_Hip_med_q','UM1_Hip_Cov')
save('UM1_Neo_Sums.mat', 'UM1_Neo_mean', 'UM1_Neo_mean_E','UM1_Neo_mean_q', 'UM1_Neo_med','UM1_Neo_med_E', 'UM1_Neo_med_q','UM1_Neo_Cov')
save('UM1_Red_Sums.mat', 'UM1_Red_mean', 'UM1_Red_mean_E','UM1_Red_mean_q', 'UM1_Red_med','UM1_Red_med_E', 'UM1_Red_med_q','UM1_Red_Cov')
save('UM1_Tra_Sums.mat', 'UM1_Tra_mean', 'UM1_Tra_mean_E','UM1_Tra_mean_q', 'UM1_Tra_med','UM1_Tra_med_E', 'UM1_Tra_med_q','UM1_Tra_Cov')

%get the mean, plus the plots
[UM2_Alc_mean, UM2_Alc_mean_q, UM2_Alc_mean_E] = FindElasticMeanFast(UM2_Alc_teeth)
[UM2_Ant_mean, UM2_Ant_mean_q, UM2_Ant_mean_E] = FindElasticMeanFast(UM2_Ant_teeth) 
[UM2_Bov_mean, UM2_Bov_mean_q, UM2_Bov_mean_E] = FindElasticMeanFast(UM2_Bov_teeth) 
[UM2_Hip_mean, UM2_Hip_mean_q, UM2_Hip_mean_E] = FindElasticMeanFast(UM2_Hip_teeth) 
[UM2_Neo_mean, UM2_Neo_mean_q, UM2_Neo_mean_E] = FindElasticMeanFast(UM2_Neo_teeth) 
[UM2_Red_mean, UM2_Red_mean_q, UM2_Red_mean_E] = FindElasticMeanFast(UM2_Red_teeth) 
[UM2_Tra_mean, UM2_Tra_mean_q, UM2_Tra_mean_E] = FindElasticMeanFast(UM2_Tra_teeth) 

%get the median, plus the plots
[UM2_Alc_med, UM2_Alc_med_q, UM2_Alc_med_E] = FindElasticMedianFast(UM2_Alc_teeth) 
[UM2_Ant_med, UM2_Ant_med_q, UM2_Ant_med_E] = FindElasticMedianFast(UM2_Ant_teeth) 
[UM2_Bov_med, UM2_Bov_med_q, UM2_Bov_med_E] = FindElasticMedianFast(UM2_Bov_teeth) 
[UM2_Hip_med, UM2_Hip_med_q, UM2_Hip_med_E] = FindElasticMedianFast(UM2_Hip_teeth) 
[UM2_Neo_med, UM2_Neo_med_q, UM2_Neo_med_E] = FindElasticMedianFast(UM2_Neo_teeth) 
[UM2_Red_med, UM2_Red_med_q, UM2_Red_med_E] = FindElasticMedianFast(UM2_Red_teeth) 
[UM2_Tra_med, UM2_Tra_med_q, UM2_Tra_med_E] = FindElasticMedianFast(UM2_Tra_teeth) 

%get the elastic covariance (around the median), plus some of the plots 
UM2_Alc_Cov = FindElasticCovarianceFast(UM2_Alc_mean, UM2_Alc_mean_q)
UM2_Ant_Cov = FindElasticCovarianceFast(UM2_Ant_mean, UM2_Ant_mean_q)
UM2_Bov_Cov = FindElasticCovarianceFast(UM2_Bov_mean, UM2_Bov_mean_q)
UM2_Hip_Cov = FindElasticCovarianceFast(UM2_Hip_mean, UM2_Hip_mean_q)
UM2_Neo_Cov = FindElasticCovarianceFast(UM2_Neo_mean, UM2_Neo_mean_q)
UM2_Red_Cov = FindElasticCovarianceFast(UM2_Red_mean, UM2_Red_mean_q)
UM2_Tra_Cov = FindElasticCovarianceFast(UM2_Tra_mean, UM2_Tra_mean_q)

%saving it 
save('UM2_Alc_Sums.mat', 'UM2_Alc_mean', 'UM2_Alc_mean_E','UM2_Alc_mean_q', 'UM2_Alc_med','UM2_Alc_med_E', 'UM2_Alc_med_q','UM2_Alc_Cov')
save('UM2_Ant_Sums.mat', 'UM2_Ant_mean', 'UM2_Ant_mean_E','UM2_Ant_mean_q', 'UM2_Ant_med','UM2_Ant_med_E', 'UM2_Ant_med_q','UM2_Ant_Cov')
save('UM2_Bov_Sums.mat', 'UM2_Bov_mean', 'UM2_Bov_mean_E','UM2_Bov_mean_q', 'UM2_Bov_med','UM2_Bov_med_E', 'UM2_Bov_med_q','UM2_Bov_Cov')
save('UM2_Hip_Sums.mat', 'UM2_Hip_mean', 'UM2_Hip_mean_E','UM2_Hip_mean_q', 'UM2_Hip_med','UM2_Hip_med_E', 'UM2_Hip_med_q','UM2_Hip_Cov')
save('UM2_Neo_Sums.mat', 'UM2_Neo_mean', 'UM2_Neo_mean_E','UM2_Neo_mean_q', 'UM2_Neo_med','UM2_Neo_med_E', 'UM2_Neo_med_q','UM2_Neo_Cov')
save('UM2_Red_Sums.mat', 'UM2_Red_mean', 'UM2_Red_mean_E','UM2_Red_mean_q', 'UM2_Red_med','UM2_Red_med_E', 'UM2_Red_med_q','UM2_Red_Cov')
save('UM2_Tra_Sums.mat', 'UM2_Tra_mean', 'UM2_Tra_mean_E','UM2_Tra_mean_q', 'UM2_Tra_med','UM2_Tra_med_E', 'UM2_Tra_med_q','UM2_Tra_Cov')

%get the mean, plus the plots
[UM3_Alc_mean, UM3_Alc_mean_q, UM3_Alc_mean_E] = FindElasticMeanFast(UM3_Alc_teeth)
[UM3_Ant_mean, UM3_Ant_mean_q, UM3_Ant_mean_E] = FindElasticMeanFast(UM3_Ant_teeth) 
[UM3_Bov_mean, UM3_Bov_mean_q, UM3_Bov_mean_E] = FindElasticMeanFast(UM3_Bov_teeth) 
[UM3_Hip_mean, UM3_Hip_mean_q, UM3_Hip_mean_E] = FindElasticMeanFast(UM3_Hip_teeth) 
[UM3_Neo_mean, UM3_Neo_mean_q, UM3_Neo_mean_E] = FindElasticMeanFast(UM3_Neo_teeth) 
[UM3_Red_mean, UM3_Red_mean_q, UM3_Red_mean_E] = FindElasticMeanFast(UM3_Red_teeth) 
[UM3_Tra_mean, UM3_Tra_mean_q, UM3_Tra_mean_E] = FindElasticMeanFast(UM3_Tra_teeth) 

%get the median, plus the plots
[UM3_Alc_med, UM3_Alc_med_q, UM3_Alc_med_E] = FindElasticMedianFast(UM3_Alc_teeth) 
[UM3_Ant_med, UM3_Ant_med_q, UM3_Ant_med_E] = FindElasticMedianFast(UM3_Ant_teeth) 
[UM3_Bov_med, UM3_Bov_med_q, UM3_Bov_med_E] = FindElasticMedianFast(UM3_Bov_teeth) 
[UM3_Hip_med, UM3_Hip_med_q, UM3_Hip_med_E] = FindElasticMedianFast(UM3_Hip_teeth) 
[UM3_Neo_med, UM3_Neo_med_q, UM3_Neo_med_E] = FindElasticMedianFast(UM3_Neo_teeth) 
[UM3_Red_med, UM3_Red_med_q, UM3_Red_med_E] = FindElasticMedianFast(UM3_Red_teeth) 
[UM3_Tra_med, UM3_Tra_med_q, UM3_Tra_med_E] = FindElasticMedianFast(UM3_Tra_teeth) 

%get the elastic covariance (around the median), plus some of the plots 
UM3_Alc_Cov = FindElasticCovarianceFast(UM3_Alc_mean, UM3_Alc_mean_q)
UM3_Ant_Cov = FindElasticCovarianceFast(UM3_Ant_mean, UM3_Ant_mean_q)
UM3_Bov_Cov = FindElasticCovarianceFast(UM3_Bov_mean, UM3_Bov_mean_q)
UM3_Hip_Cov = FindElasticCovarianceFast(UM3_Hip_mean, UM3_Hip_mean_q)
UM3_Neo_Cov = FindElasticCovarianceFast(UM3_Neo_mean, UM3_Neo_mean_q)
UM3_Red_Cov = FindElasticCovarianceFast(UM3_Red_mean, UM3_Red_mean_q)
UM3_Tra_Cov = FindElasticCovarianceFast(UM3_Tra_mean, UM3_Tra_mean_q)

%saving it 
save('UM3_Alc_Sums.mat', 'UM3_Alc_mean', 'UM3_Alc_mean_E','UM3_Alc_mean_q', 'UM3_Alc_med','UM3_Alc_med_E', 'UM3_Alc_med_q','UM3_Alc_Cov')
save('UM3_Ant_Sums.mat', 'UM3_Ant_mean', 'UM3_Ant_mean_E','UM3_Ant_mean_q', 'UM3_Ant_med','UM3_Ant_med_E', 'UM3_Ant_med_q','UM3_Ant_Cov')
save('UM3_Bov_Sums.mat', 'UM3_Bov_mean', 'UM3_Bov_mean_E','UM3_Bov_mean_q', 'UM3_Bov_med','UM3_Bov_med_E', 'UM3_Bov_med_q','UM3_Bov_Cov')
save('UM3_Hip_Sums.mat', 'UM3_Hip_mean', 'UM3_Hip_mean_E','UM3_Hip_mean_q', 'UM3_Hip_med','UM3_Hip_med_E', 'UM3_Hip_med_q','UM3_Hip_Cov')
save('UM3_Neo_Sums.mat', 'UM3_Neo_mean', 'UM3_Neo_mean_E','UM3_Neo_mean_q', 'UM3_Neo_med','UM3_Neo_med_E', 'UM3_Neo_med_q','UM3_Neo_Cov')
save('UM3_Red_Sums.mat', 'UM3_Red_mean', 'UM3_Red_mean_E','UM3_Red_mean_q', 'UM3_Red_med','UM3_Red_med_E', 'UM3_Red_med_q','UM3_Red_Cov')
save('UM3_Tra_Sums.mat', 'UM3_Tra_mean', 'UM3_Tra_mean_E','UM3_Tra_mean_q', 'UM3_Tra_med','UM3_Tra_med_E', 'UM3_Tra_med_q','UM3_Tra_Cov')


%PCA plots
%[LM3_Tra_PC1_vec_plot,LM3_Tra_PC2_vec_plot,LM3_Tra_PC3_vec_plot,LM3_Tra_PC1_Mag_plot,LM3_Tra_PC2_Mag_plot,LM3_Tra_PC3_Mag_plot ] = PCA_plots(LM3_Tra_mean,LM3_Tra_mean_q)




