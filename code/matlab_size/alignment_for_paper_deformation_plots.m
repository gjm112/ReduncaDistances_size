qX = readtable("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/qX.csv")
qY = readtable("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/qY.csv")

qX = table2array(qX)
qY = table2array(qY)


[q2n,R] = Find_Rotation_and_Seed_unique(qX, qY, 1)

q2n = ProjectC(q2n);


csvwrite("/Users/gregorymatthews/Dropbox/full_shape_classification_SRVF_preserving_size/qY_registered.csv",q2n)