function [VV,PC_feat] = FindTangentFeatures(mu,q,numPCs)

close all;

reparamFlag = 1;

%a: is the number of coords for each point we have on the curve (2 here)
%b: the number of points we have sampled on each curve
%n: the number of curves in our sample 
[a,b,n]=size(q);

%for each curve in the sample, get the shooting vector from mu to the curve
%register each of these curves to mu
for i=1:n
    i
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

Ured=U(:,1:numPCs);
PC_feat=VV*Ured;