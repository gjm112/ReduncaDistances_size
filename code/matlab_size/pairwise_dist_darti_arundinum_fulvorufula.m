wd = "/Users/gregorymatthews/Dropbox"
cd /Users/gregorymatthews/Dropbox/ReduncaDistances_sizeGit/code/matlab_size
toothtype = {"LM1","LM2","LM3","UM1","UM2","UM3"}
species = {"darti", "arundinum","fulvorufula"}
for t=1:6

        data_darti = readtable(wd + "/ReduncaDistances_sizeGit/data/matlab/data_"+toothtype(t)+"_darti.csv")
        data_arundinum = readtable(wd + "/ReduncaDistances_sizeGit/data/matlab/data_"+toothtype(t)+"_arundinum.csv")
        data_fulvorufula = readtable(wd + "/ReduncaDistances_sizeGit/data/matlab/data_"+toothtype(t)+"_fulvorufula.csv")
data=[data_darti; data_arundinum; data_fulvorufula] 
        
        %get the number of rows and cols
        n_rows = size(data,1);
        n_cols = size(data,2);
        
        %blank array storage for matrix for each image
        teeth_data = zeros(2,100,n_rows/2);
        
        
        %loop to assign each tooth's coordinates to the appropriate spot in the
        %array
        for i=1:2:n_rows
            %get index for the image we are on 
            j = find((1:2:n_rows)==i);
            
            %assign matrix for image j 
             X = data{i:(i+1), 2:n_cols};
            
            %resample so all of the curves have 100 points
            teeth_data(:,:,j) = ReSampleCurve(X,100);
        end
        
        cd /Users/gregorymatthews/Dropbox/ReduncaDistances_sizeGit/code/matlab_size

         ddd = FindPairwiseDistance(teeth_data)

    
        save(wd + "/ReduncaDistances_sizeGit/data/matlab/pairwise_distances_"+toothtype(t)+".mat","ddd")
        csvwrite(wd + "/ReduncaDistances_sizeGit/data/matlab/pairwise_distances_"+toothtype(t)+".csv",ddd)

end  
        
        

