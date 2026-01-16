cd /Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/data/means
toothtype = {"LM1","LM2","LM3","UM1","UM2","UM3"}
tribe = {"Alcelaphini","Antilopini","Bovini","Hippotragini","Neotragini","overall","Reduncini","Tragelaphini"}
for trib=1:8
    for t=1:6
        load("mean_"+toothtype(t)+"_"+tribe(trib)+".mat")
        csvwrite("mean_"+toothtype(t)+"_"+tribe(trib)+".csv",mean)
    end
end