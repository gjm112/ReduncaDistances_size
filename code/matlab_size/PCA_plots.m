%this script replicates the plots on page 1043 of Kurtek et. al. 

%these plots display the covariance structre in the data displayed using
%the first three principal components 

function [PC1_vec_plot,PC2_vec_plot,PC3_vec_plot,PC1_Mag_plot,PC2_Mag_plot,PC3_Mag_plot ] = PCA_plots(mu,q)

%mu is the mean of the dataset
%q has each of the curves in SRVF form 
%both mu and q are outputs of FindElasticMean

%PCA code 

%tell it to reparameterize
reparamFlag = 1;

%a: is the number of coords for each point we have on the curve (2 here)
%b: the number of points we have sampled on each curve
%n: the number of curves in our sample 
[a,b,n]=size(q);

%for each curve in the sample, get the shooting vector from mu to the curve
%register each of these curves to mu
for i=1:n
    tmp = ElasticShootingVector(mu,q(:,:,i),reparamFlag);
    %in row i, cols 1 to b, place the x cords of v
    %in row i, cols b+1 to 2*b, place the y cords of v 
    VV(i,1:b) = tmp(1,:);
    VV(i,b+1:2*b) = tmp(2,:);
end

%covariance of VV
K = cov(VV);
%singluar value decomp of VV 
%V is U^T
%S is Sigma, has n-1 non-zero diagonal elements
[U,S,V] = svd(K);

%get x,y coords for PC1, PC2, and PC3 by making the first three columns of
%U into 2xn matrices
PC1 = [U((1:b),1)';U(((b+1):2*b),1)'];
PC2 = [U((1:b),2)';U(((b+1):2*b),2)'];
PC3 = [U((1:b),3)';U(((b+1):2*b),3)'];

% Three plots which display the mean curve (blue) with the vector fields for PC1, PC2, and PC3

muc=q_to_curve(mu);
PC1_vec_plot = figure('Name', 'PC1 with Vectors'), clf;
%first plot the mean in blue 
plot(muc(1,:),muc(2,:),'k','LineWidth',1)
hold on;
%add on the vector fields
quiver(muc(1,:),muc(2,:), PC1(1,:),PC1(2,:),0.5, '.-m', 'LineWidth',1.5);
axis equal off; view([1 90]);

PC2_vec_plot = figure('Name', 'PC2 with Vectors'), clf;
%first plot the mean in blue 
plot(muc(1,:),muc(2,:),'k','LineWidth',1)
hold on;
%add on the vector fields
quiver(muc(1,:),muc(2,:), PC2(1,:),PC2(2,:),0.5, '.-m', 'LineWidth',1.5);
axis equal off; view([1 90]);

PC3_vec_plot = figure('Name', 'PC3 with Vectors'), clf;
%first plot the mean in blue 
plot(muc(1,:),muc(2,:),'k','LineWidth',1)
hold on;
%add on the vector fields
quiver(muc(1,:),muc(2,:), PC3(1,:),PC3(2,:),0.5, '.-m', 'LineWidth',1.5);
axis equal off; view([1 90]);

% Three plots which display the mean curve with the magnitude of the vector fields for PC1, PC2, and PC3

%get the color scale by taking the norm of each set of coordinates 
PC1col_norm = zeros(1,b);
for i=1:b 
    PC1col_norm(i) = norm(PC1(:,i));
end

PC2col_norm = zeros(1,b);
for i=1:b 
    PC2col_norm(i) = norm(PC2(:,i));
end

PC3col_norm = zeros(1,b);
for i=1:b 
    PC3col_norm(i) = norm(PC3(:,i));
end

PC1_Mag_plot = figure('Name', 'PC1 with Magnitude'), clf;
%use scatter to plot the points with color determined by mag. 
scatter(muc(1,:),muc(2,:),[],PC1col_norm, 'filled');
colormap turbo;
cb = colorbar();
axis equal off; view([1 90]);

PC2_Mag_plot = figure('Name', 'PC2 with Magnitude'), clf;
%use scatter to plot the points with color determined by mag. 
scatter(muc(1,:),muc(2,:),[],PC2col_norm, 'filled');
colormap turbo;
cb = colorbar();
axis equal off; view([1 90]);

PC3_Mag_plot = figure('Name', 'PC3 with Magnitude'), clf;
%use scatter to plot the points with color determined by mag. 
scatter(muc(1,:),muc(2,:),[],PC3col_norm, 'filled');
colormap turbo;
cb = colorbar();
axis equal off; view([1 90]);

end
