

teethBWgladysvale500matrix = readtable("/Users/gregorymatthews/Dropbox/gladysvale/teeth_BW_gladysvale_500_matrix.csv")

teethBWgladysvale500matrix = renamevars(teethBWgladysvale500matrix,["Var1"],["image"])


cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF/code/matlab/
%get the number of rows and cols
n_rows = size(teethBWgladysvale500matrix,1);
n_cols = size(teethBWgladysvale500matrix,2);

%blank array storage for matrix for each image
teeth_data = zeros(2,100,n_rows/2);


%loop to assign each tooth's coordinates to the appropriate spot in the
%array
for i=1:2:n_rows
    %get index for the image we are on 
    j = find((1:2:n_rows)==i);
    
    %assign matrix for image j 
     X = teethBWgladysvale500matrix{i:(i+1), 2:n_cols};
    
    %resample so all of the curves have 100 points
    teeth_data(:,:,j) = ReSampleCurve(X,100);
end


% get image ids in order 
teeth_ref_gladysvale = teethBWgladysvale500matrix.image(1:2:n_rows);

%% sort so that the images in teeth_data are in the same order as the variables in teeth_ref
teeth_data_gladysvale = teeth_data


% save the teeth_data and teeth_ref in one .dat file
cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF/data/gladysvale
save('teeth_data_gladysvale')
save('teeth_ref_gladysvale')

