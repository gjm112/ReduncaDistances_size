

cd /Users/nastaranghorbani/Documents/size/code/matlab_size

toothtype = {"LM1","LM2","LM3","UM1","UM2","UM3"};
species = {"scriptus","pricei"};

data = struct(); 

for t = 1:length(toothtype)
    for sp = 1:length(species)
        varName = toothtype{t} + "_" + species{sp}; 
        filePath = "/Users/nastaranghorbani/Documents/size/data/matlab/out_beta_" + toothtype{t} + "_" + species{sp} + ".mat";
        temp = load(filePath); 
        data.(varName) = temp.out_beta; % Extract the out_beta field from the loaded structure
    end
end


toothtype = {"LM1","LM2","LM3","UM1","UM2","UM3"};
species = {"scriptus","pricei"};

for t = 1:length(toothtype)
    for sp = 1:length(species)
        varName = toothtype{t} + "_" + species{sp}; 
        q1 = curve_to_q(data.(varName));
        
        for sp2 = 1:length(species)
            if sp2 ~= sp
                varName2 = toothtype{t} + "_" + species{sp2};
                q2 = curve_to_q(data.(varName2));
                q2new = Find_Rotation_and_Seed_unique_fast(q1, q2, 0);
                
                first = q_to_curve(q1);
                second = q_to_curve(q2new);
                
                % Save the first and second curves as CSV files
                
                %csvwrite('/Users/nastaranghorbani/Documents/shape/data/plots/csv/first.csv', first);
                %csvwrite("/Users/nastaranghorbani/Documents/shape/data/plots/csv/matlab/VV_"+toothtype(t)+"_combined.csv",VV)

                csvwrite("/Users/nastaranghorbani/Documents/size/data/plots/csv/"+varName+ ".csv", first);
                csvwrite("/Users/nastaranghorbani/Documents/size/data/plots/csv/"+varName+ ".csv", second);
            end
        end
    end
end
