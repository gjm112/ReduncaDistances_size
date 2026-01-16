cd /Users/gregorymatthews/Dropbox/combining_rules_for_shapes/
load('out_q')

sim_shapes = readtable("/Users/gregorymatthews/Dropbox/combining_rules_for_shapes/simulated_shapes_in_tan_space.csv")


cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF/code/matlab/
%get the number of rows and cols
n_rows = size(sim_shapes,1);
n_cols = size(sim_shapes,2); 

%blank array storage for matric for each image
sim_shapes_data = zeros(2,n_cols,n_rows/2);

for i=1:2:n_rows
    %get index for the image we are on 
    j = find((1:2:n_rows)==i);
    
    %assign matrix for image j 
     X = sim_shapes{i:(i+1), 2:n_cols};
    
    %resample so all of the curves have 100 points
    sim_shapes_data(:,:,j) = ReSampleCurve(X,n_cols);
end

[a b n] = size(sim_shapes_data)

sim_shapes_data_shapespace = zeros(2,n_cols,n_rows/2);
for i=1:n
    i
    sim_shapes_data_shapespace_q(:,:,i) = ElasticShooting(out_q,sim_shapes_data(:,:,i));
    sim_shapes_data_shapespace_beta(:,:,i) = q_to_curve(sim_shapes_data_shapespace_q(:,:,i))

    WW(i,1:b) = sim_shapes_data_shapespace_beta(1,:,i)
    WW(i,b+1:2*b) = sim_shapes_data_shapespace_beta(2,:,i)
end


csvwrite("/Users/gregorymatthews/Dropbox/combining_rules_for_shapes/sim_shapes_data_shapespace_beta.csv",WW)


