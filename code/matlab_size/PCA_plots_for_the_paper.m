

mean = table2array(readtable("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/means/mean_LM1_Alcelaphini.csv"))
ref = readtable("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/fulldata/LM1_train_reference.csv")
VV = readtable("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/fulldata/LM1_train_individual.csv")
VV = VV(ref.tribe == "Alcelaphini",1:200)
VV = table2array(VV);

K = cov(VV);
%singluar value decomp of VV 
%V is U^T
%S is Sigma, has n-1 non-zero diagonal elements
[U,S,V] = svd(K);

%1:2:n_rows
for PCnum = 1:3;
pc_beta_data = zeros(100,2,7);
    for k= -3:3
        temp = mean + transpose([k/2*sqrt(S(PCnum,PCnum))*U(1:100,PCnum), k/2*sqrt(S(PCnum,PCnum))*U(101:200,PCnum)])
        pc_beta_data(:,:,k+4) = transpose(q_to_curve(ProjectC(temp)))
    end

out = [pc_beta_data(:,:,1);
 pc_beta_data(:,:,2);
 pc_beta_data(:,:,3);
 pc_beta_data(:,:,4);
 pc_beta_data(:,:,5);
 pc_beta_data(:,:,6);
 pc_beta_data(:,:,7)]


  csvwrite("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/PC"+PCnum+"_for_plot.csv",out)

end
  
  
  
