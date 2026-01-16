teethBWgladysvale500matrix = readtable("/Users/gregorymatthews/Dropbox/gladysvale/teeth_BW_gladysvale_500_matrix.csv")

teethBWgladysvale500matrix = renamevars(teethBWgladysvale500matrix,["Var1"],["image"])


cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/code/matlab/
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

cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/fulldata
 % Write the table to a CSV file
writetable(cell2table(teeth_ref_gladysvale),strcat("gladysvale_reference.csv"))
    

%% sort so that the images in teeth_data are in the same order as the variables in teeth_ref
teeth_data_gladysvale = teeth_data


% save the teeth_data and teeth_ref in one .dat file
cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/
save('teeth_data_gladysvale')
save('teeth_ref_gladysvale')



%Project on the means that have already been found
%No tooth type for now because I don't have it. 
for toothtype = ["LM1","LM2","LM3","UM1","UM2","UM3"]
    %teeth = teeth_data(:,:,teeth_ref.type == toothtype);
    teeth = teeth_data_gladysvale
    %ref = teeth_ref(teeth_ref.type==toothtype,:);
    cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/means
    load(strcat("mean_",toothtype,"_overall"))
    
    %FindTangentFeatures(mu,q,numPCs)
    cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/code/matlab
    sz = size(teeth)
        q = teeth
        for j=1:sz(3)
         q(:,:,j) = curve_to_q(teeth(:,:,j));
         end
    [VV,PC] = FindTangentFeatures(mean,q,min(sz(3) - 1,30))
    %csvwrite(filename,M) writes matrix M to file filename as comma-separated values.
    
    cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/fulldata/
    
    csvwrite(strcat(toothtype,"_gladysvale_overall.csv"), VV)
    %PCs won't really mean anything here, right? 
    %csvwrite(strcat(toothtype,"_train_overall_PC.csv"), PC)

    i = 0
    out_all = repmat(0,[sz(3) 2*sz(2), 7])
    out_pc = repmat(0,[sz(3) min(sz(3) - 1,30), 7])
    for tribe = ["Alcelaphini","Antilopini","Bovini","Hippotragini","Neotragini","Reduncini","Tragelaphini"]
        i = i + 1
        disp(i)
        teeth = teeth_data_gladysvale

        cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/means
        load(strcat("mean_",toothtype,"_",tribe))
    
        %FindTangentFeatures(mu,q,numPCs)
        cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/code/matlab
        sz = size(teeth)
            q = teeth
        for j=1:sz(3)
         q(:,:,j) = curve_to_q(teeth(:,:,j));
         end
        [VV,PC] = FindTangentFeatures(mean,q,min(sz(3) - 1,30))
        
        out_all(:,:,i) = VV
        %out_pc(:,:,i) = PC
    end

    %concatenate all of them
    gladysvale_individual = horzcat(out_all(:,:,1), ...
        out_all(:,:,2), ...
        out_all(:,:,3), ...
        out_all(:,:,4), ...
        out_all(:,:,5), ...
        out_all(:,:,6), ...
        out_all(:,:,7))

    cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/fulldata 
    csvwrite(strcat(toothtype,"_gladysvale_individual.csv"), gladysvale_individual)
    

    %Concatenate all of them
    %train_individual_PC = horzcat(out_all(:,:,1), ...
    %    out_pc(:,:,2), ...
    %    out_pc(:,:,3), ...
    %    out_pc(:,:,4), ...
    %    out_pc(:,:,5), ...
    %    out_pc(:,:,6), ...
    %    out_pc(:,:,7))

    %csvwrite(strcat(toothtype,"_train_individual_PC.csv"), train_individual_PC)

end



