%project all objects onto the tangent space of the overall mean of the 
%training data and save the x,y coordinates as an n x 2*p*m array where
%n is the number of objects, p is the number of points on each object, 
%m is the number of categories we have 

%coords: n x 2*p matrix with coordinates from project each object onto
%each of the category means. Each set of coordinates is 200 long
%names_cats: has the names of the categories in the order the coordinates
%were placed into coords

function [coords_overall,names_cats] = OverallTrainTangentFeatures(data, cat_vec, train_ind)
%data:2xpxn array containing the curves
%cat_vec: is an n length vector with the categories we would
%like to classify by
%train_ind: vector with indicators if an observation is in the training
%data

%this gives the number of matrices/curves we have in our dataset
n=size(data,3);

%this gives the number of points we havae on each curve
p=size(data,2);

%get the labels of the categories 
tbl = tabulate(cat_vec);
names_cats = string(tbl(:,1));

%this is the number of categories we have 
m = length(names_cats);

%get training data
train_data = data(:,:,train_ind);

%find the overall mean of the training data so we can use it to initialize
mean_overall = FindElasticMeanFast(train_data);

%storage for the coordinates
coords_overall = NaN(n,2*p);

%for each curve in the sample, get the shooting vector from the training mean 
%to the curve and save the coordinates  
for j=1:n
    %make sure everything is in SRVF
    X = ReSampleCurve(data(:,:,j),p);
    q = curve_to_q(X);

    tmp = ElasticShootingVectorFast(mean_overall,q,1);
    %in row j, cols 1 to p, place the x cords of v
    %in row j, cols p+1 to 2*p, place the y cords of v 
    coords_overall(j,:) = [tmp(1,:),tmp(2,:)];
end
end
