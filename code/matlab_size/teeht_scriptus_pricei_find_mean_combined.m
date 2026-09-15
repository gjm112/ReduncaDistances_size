wd = "/Users/gregorymatthews/Dropbox"
cd /Users/gregorymatthews/Dropbox/ReduncaDistances_sizeGit/code/matlab_size
%The data set that gets read in here is the same for both shape only and
%size-and-shape.  The difference is that that functions here do not remove
%the size
toothtype = {"LM1","LM2","LM3","UM1","UM2","UM3"}
species = {"darti", "arundinum"}
for t=1:6

        data_darti = readtable(wd + "/ReduncaDistances_sizeGit/data/matlab/data_"+toothtype(t)+"_darti.csv")
        data_arundinum = readtable(wd + "/ReduncaDistances_sizeGit/data/matlab/data_"+toothtype(t)+"_arundinum.csv")
       %data_fulvorufula = readtable(wd + "/ReduncaDistances_sizeGit/data/matlab/data_"+toothtype(t)+"_fulvorufula.csv")
data=[data_darti; data_arundinum] 

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
        
        %Compute mean
        [out_q,q,E] = FindElasticMean(teeth_data)
        out_beta = q_to_curve(out_q)
        [VV,PC_feat]=FindTangentFeatures(out_q,q,10)


        
        %Now save the average tooth
        save(wd+"/ReduncaDistances_sizeGit/data/matlab/VV_"+toothtype(t)+"_combined.mat","VV")
        save(wd+"/ReduncaDistances_sizeGit/data/matlab/PC_feat_"+toothtype(t)+"_combined.mat","PC_feat")
        save(wd+"/ReduncaDistances_sizeGit/data/matlab/out_beta_"+toothtype(t)+"_combined.mat","out_beta")

csvwrite(wd+"/ReduncaDistances_sizeGit/data/matlab/VV_"+toothtype(t)+"_combined.csv",VV)
csvwrite(wd+"/ReduncaDistances_sizeGit/data/matlab/PC_feat_"+toothtype(t)+"_combined.csv",PC_feat)
csvwrite(wd+"/ReduncaDistances_sizeGit/data/matlab/out_beta_"+toothtype(t)+"_combined.csv",out_beta)

end  
        
        

