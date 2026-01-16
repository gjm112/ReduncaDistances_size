%this uses GeodesicElasticClosedFast_NS.m to find the pairwise distances between
%each closed curve in a dataset 

%the output will be a n x n symmetric matrix of distances with 0s on the
%diagonal 

function d_mat = FindPairwiseDistanceFast(data)
%this gives the number of matrices/curves we have in our dataset
n=size(data,3);

%creates an n x n matrix of 0's to store distances in 
d_mat = zeros(n,n);

%this loop with fill the upper triangle of the matrix with distances,
%leaving 0's on the diagonal

for i=1:n
   for j=(i+1):n
       row_col = [i,j]
       d_mat(i,j) = GeodesicElasticClosedFast_NS(data(:,:,i),data(:,:,j));
   end
end

%fill in the rest of d by adding the transpose
d_mat = d_mat + d_mat.';
end
