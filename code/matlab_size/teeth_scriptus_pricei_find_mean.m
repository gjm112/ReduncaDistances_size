wd = "/Users/gregorymatthews/Dropbox"
cd /Users/gregorymatthews/Dropbox/teeth-scriptus-pricei-size/code/matlab_size/
toothtype = {"LM1","LM2","LM3","UM1","UM2","UM3"}
species = {"pricei", "scriptus"}
for t=1:6
    for sp=1:2
        %The input data is the same for size-and-shape and shape only
        data = readtable(wd + "/teeth-scriptus-pricei/data/matlab/data_"+toothtype(t)+"_"+species(sp)+".csv")
        
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
        save(wd +"/teeth-scriptus-pricei-size/data/matlab/VV_"+toothtype(t)+"_"+species(sp)+".mat","VV")
        save(wd +"/teeth-scriptus-pricei-size/data/matlab/PC_feat_"+toothtype(t)+"_"+species(sp)+".mat","PC_feat")
        save(wd +"/teeth-scriptus-pricei-size/data/matlab/out_beta_"+toothtype(t)+"_"+species(sp)+".mat","out_beta")

csvwrite(wd +"/teeth-scriptus-pricei-size/data/matlab/VV_"+toothtype(t)+"_"+species(sp)+".csv",VV)
csvwrite(wd +"/teeth-scriptus-pricei-size/data/matlab/PC_feat_"+toothtype(t)+"_"+species(sp)+".csv",PC_feat)
csvwrite(wd +"/teeth-scriptus-pricei-size/data/matlab/out_beta_"+toothtype(t)+"_"+species(sp)+".csv",out_beta)

    end
end  
        
        

