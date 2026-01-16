%this script with format the update teeth data into the form we would like 

%Two files with data:
teethBWtrain500matrix20210622 = readtable("/Users/gregorymatthews/Dropbox/gladysvale/teeth_BW_train_500_matrix_20210622.csv")
teethBWgladysvale500matrix = renamevars(teethBWgladysvale500matrix,["Var1"],["image"])


referencefile20210622 = readtable("/Users/gregorymatthews/Dropbox/gladysvale/reference_file_20210622.csv")
teethBWgladysvale500matrix = renamevars(teethBWgladysvale500matrix,["Var1"],["image"])

%teethBWtrain500matrix20210622 is a file with 7070
%rows and 501 columns. The first column is the image number and the other
%500 rows are sample x and y coordinates. Each pair of rows (so 1:2,
%3:4,...) are the x,y coords for an image. (3535 images total)

%referencefile20210622 is a file with information about 3909 images. the
%columns are variable numbers and it contains the same image numbers used
%in teethBWtrain...

%% Subset referencefile so that it only has the images in teethBWtain

%this gives the unique image names in teethBWtrain 
image_unique = unique(teethBWtrain500matrix20210622.image);

%1 is the image in referencefile is in teethBWtrain and 0 otherwise
%this has 3 more observations than we have in teethBWtrain, duplicates?
ref_in_teeth = ismember(referencefile20210622.image, image_unique);

%subset referencefile to only have rows with 1 in ref_in_teeth
%this has 303 more observations than we have in teethBWtrain
%these are duplicates and we can remove them for our analysis 
reference_file = referencefile20210622(ref_in_teeth,:);

%get the index to the unique images, we will just use the first occurance
%of duplicates 
[uniqueA i j] = unique(reference_file.image,'first');
indexToUnique = find(ismember(1:numel(reference_file.image),i));

%final subset to get the reference file we want
teeth_ref = reference_file(indexToUnique,:); 

%extract the variables from teeth_ref that we want 
teeth_ref = teeth_ref(:, {'family','tribe','genus','species','type','image','complete','corrupt'});

%save teeth_ref
%save('teeth_ref.mat','teeth_ref')

%% format the teethBWtrain dataset into a set of 3535 2x500 matrices
%split into 2x500x3535 multidim array 

%get the number of rows and cols
n_rows = size(teethBWtrain500matrix20210622,1);
n_cols = size(teethBWtrain500matrix20210622,2);

%blank array storage for matric for each image
teeth_data = zeros(2,100,n_rows/2);

%loop to assign each tooth's coordinates to the appropriate spot in the
%array
for i=1:2:n_rows
    %get index for the image we are on 
    j = find((1:2:n_rows)==i);
    
    %assign matrix for image j 
     X = teethBWtrain500matrix20210622{i:(i+1), 2:n_cols};
    
    %resample so all of the curves have 100 points
    teeth_data(:,:,j) = ReSampleCurve(X,100);
end

% get image ids in order 
teeth_data_ids = teethBWtrain500matrix20210622.image(1:2:n_rows);

%% sort so that the images in teeth_data are in the same order as the variables in teeth_ref

% get the location index in teeth_ref.image for each id in teeth_data
[temp,order] = ismember(teeth_data_ids,teeth_ref.image);

%sort teeth_ref so it is in the same order as the images in teeth_data
teeth_ref = teeth_ref(order,:);

% save the teeth_data and teeth_ref in one .dat file
save('teeth_data_20210622.mat','teeth_ref','teeth_data')

%% split teeth into type 

%LM1
LM1_teeth = teeth_data(:,:,teeth_ref.type=='LM1');
LM1_ref = teeth_ref(teeth_ref.type=='LM1',:);
LM1_ref.tribe=removecats(LM1_ref.tribe); %remove extra tribe label 
save('LM1_data_20210622.mat','LM1_teeth','LM1_ref')

%LM2
LM2_teeth = teeth_data(:,:,teeth_ref.type=='LM2');
LM2_ref = teeth_ref(teeth_ref.type=='LM2',:); 
LM2_ref.tribe=removecats(LM2_ref.tribe); %remove extra tribe label 
save('LM2_data_20210622.mat','LM2_teeth','LM2_ref')

%LM3
LM3_teeth = teeth_data(:,:,teeth_ref.type=='LM3');
LM3_ref = teeth_ref(teeth_ref.type=='LM3',:);
LM3_ref.tribe=removecats(LM3_ref.tribe); %remove extra tribe label 
save('LM3_data_20210622.mat','LM3_teeth','LM3_ref')

%UM1
UM1_teeth = teeth_data(:,:,teeth_ref.type=='UM1');
UM1_ref = teeth_ref(teeth_ref.type=='UM1',:);
UM1_ref.tribe=removecats(UM1_ref.tribe); %remove extra tribe label 
save('UM1_data_20210622.mat','UM1_teeth','UM1_ref')

%UM2
UM2_teeth = teeth_data(:,:,teeth_ref.type=='UM2');
UM2_ref = teeth_ref(teeth_ref.type=='UM2',:);
UM2_ref.tribe=removecats(UM2_ref.tribe); %remove extra tribe label 
save('UM2_data_20210622.mat','UM2_teeth','UM2_ref')

%LM3
UM3_teeth = teeth_data(:,:,teeth_ref.type=='UM3');
UM3_ref = teeth_ref(teeth_ref.type=='UM3',:);
UM3_ref.tribe=removecats(UM3_ref.tribe); %remove extra tribe label 
save('UM3_data_20210622.mat','UM3_teeth','UM3_ref')

%% LM1: split into tribes

%Alcelaphini
LM1_Alc_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Alcelaphini');
LM1_Alc_ref = LM1_ref(LM1_ref.tribe == 'Alcelaphini',:);
save('LM1_Alcelaphini_20210622.mat', 'LM1_Alc_teeth', 'LM1_Alc_ref');

%Antilopini 
LM1_Ant_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Antilopini');
LM1_Ant_ref = LM1_ref(LM1_ref.tribe == 'Antilopini',:);
save('LM1_Antilopini_20210622.mat', 'LM1_Ant_teeth', 'LM1_Ant_ref');

%Bovini
LM1_Bov_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Bovini');
LM1_Bov_ref = LM1_ref(LM1_ref.tribe == 'Bovini',:);
save('LM1_Bovini_20210622.mat', 'LM1_Bov_teeth', 'LM1_Bov_ref');

%Hippotragini
LM1_Hip_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Hippotragini');
LM1_Hip_ref = LM1_ref(LM1_ref.tribe == 'Hippotragini',:);
save('LM1_Hippotragini_20210622.mat', 'LM1_Hip_teeth', 'LM1_Hip_ref');

%Neotragini
LM1_Neo_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Neotragini');
LM1_Neo_ref = LM1_ref(LM1_ref.tribe == 'Neotragini',:);
save('LM1_Neotragini_20210622.mat', 'LM1_Neo_teeth', 'LM1_Neo_ref');

%Reduncini
LM1_Red_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Reduncini');
LM1_Red_ref = LM1_ref(LM1_ref.tribe == 'Reduncini',:);
save('LM1_Reduncini_20210622.mat', 'LM1_Red_teeth', 'LM1_Red_ref');

%Tragelaphini
LM1_Tra_teeth = LM1_teeth(:,:,LM1_ref.tribe == 'Tragelaphini');
LM1_Tra_ref = LM1_ref(LM1_ref.tribe == 'Tragelaphini',:);
save('LM1_Tragelaphini_20210622.mat', 'LM1_Tra_teeth', 'LM1_Tra_ref');

%% LM2: split into tribes

%Alcelaphini
LM2_Alc_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Alcelaphini');
LM2_Alc_ref = LM2_ref(LM2_ref.tribe == 'Alcelaphini',:);
save('LM2_Alcelaphini_20210622.mat', 'LM2_Alc_teeth', 'LM2_Alc_ref');

%Antilopini 
LM2_Ant_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Antilopini');
LM2_Ant_ref = LM2_ref(LM2_ref.tribe == 'Antilopini',:);
save('LM2_Antilopini_20210622.mat', 'LM2_Ant_teeth', 'LM2_Ant_ref');

%Bovini
LM2_Bov_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Bovini');
LM2_Bov_ref = LM2_ref(LM2_ref.tribe == 'Bovini',:);
save('LM2_Bovini_20210622.mat', 'LM2_Bov_teeth', 'LM2_Bov_ref');

%Hippotragini
LM2_Hip_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Hippotragini');
LM2_Hip_ref = LM2_ref(LM2_ref.tribe == 'Hippotragini',:);
save('LM2_Hippotragini_20210622.mat', 'LM2_Hip_teeth', 'LM2_Hip_ref');

%Neotragini
LM2_Neo_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Neotragini');
LM2_Neo_ref = LM2_ref(LM2_ref.tribe == 'Neotragini',:);
save('LM2_Neotragini_20210622.mat', 'LM2_Neo_teeth', 'LM2_Neo_ref');

%Reduncini
LM2_Red_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Reduncini');
LM2_Red_ref = LM2_ref(LM2_ref.tribe == 'Reduncini',:);
save('LM2_Reduncini_20210622.mat', 'LM2_Red_teeth', 'LM2_Red_ref');

%Tragelaphini
LM2_Tra_teeth = LM2_teeth(:,:,LM2_ref.tribe == 'Tragelaphini');
LM2_Tra_ref = LM2_ref(LM2_ref.tribe == 'Tragelaphini',:);
save('LM2_Tragelaphini_20210622.mat', 'LM2_Tra_teeth', 'LM2_Tra_ref');

%% LM3: split into tribes

%Alcelaphini
LM3_Alc_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Alcelaphini');
LM3_Alc_ref = LM3_ref(LM3_ref.tribe == 'Alcelaphini',:);
save('LM3_Alcelaphini_20210622.mat', 'LM3_Alc_teeth', 'LM3_Alc_ref');

%Antilopini 
LM3_Ant_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Antilopini');
LM3_Ant_ref = LM3_ref(LM3_ref.tribe == 'Antilopini',:);
save('LM3_Antilopini_20210622.mat', 'LM3_Ant_teeth', 'LM3_Ant_ref');

%Bovini
LM3_Bov_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Bovini');
LM3_Bov_ref = LM3_ref(LM3_ref.tribe == 'Bovini',:);
save('LM3_Bovini_20210622.mat', 'LM3_Bov_teeth', 'LM3_Bov_ref');

%Hippotragini
LM3_Hip_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Hippotragini');
LM3_Hip_ref = LM3_ref(LM3_ref.tribe == 'Hippotragini',:);
save('LM3_Hippotragini_20210622.mat', 'LM3_Hip_teeth', 'LM3_Hip_ref');

%Neotragini
LM3_Neo_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Neotragini');
LM3_Neo_ref = LM3_ref(LM3_ref.tribe == 'Neotragini',:);
save('LM3_Neotragini_20210622.mat', 'LM3_Neo_teeth', 'LM3_Neo_ref');

%Reduncini
LM3_Red_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Reduncini');
LM3_Red_ref = LM3_ref(LM3_ref.tribe == 'Reduncini',:);
save('LM3_Reduncini_20210622.mat', 'LM3_Red_teeth', 'LM3_Red_ref');

%Tragelaphini
LM3_Tra_teeth = LM3_teeth(:,:,LM3_ref.tribe == 'Tragelaphini');
LM3_Tra_ref = LM3_ref(LM3_ref.tribe == 'Tragelaphini',:);
save('LM3_Tragelaphini_20210622.mat', 'LM3_Tra_teeth', 'LM3_Tra_ref');


%% UM1: split into tribes

%Alcelaphini
UM1_Alc_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Alcelaphini');
UM1_Alc_ref = UM1_ref(UM1_ref.tribe == 'Alcelaphini',:);
save('UM1_Alcelaphini_20210622.mat', 'UM1_Alc_teeth', 'UM1_Alc_ref');

%Antilopini 
UM1_Ant_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Antilopini');
UM1_Ant_ref = UM1_ref(UM1_ref.tribe == 'Antilopini',:);
save('UM1_Antilopini_20210622.mat', 'UM1_Ant_teeth', 'UM1_Ant_ref');

%Bovini
UM1_Bov_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Bovini');
UM1_Bov_ref = UM1_ref(UM1_ref.tribe == 'Bovini',:);
save('UM1_Bovini_20210622.mat', 'UM1_Bov_teeth', 'UM1_Bov_ref');

%Hippotragini
UM1_Hip_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Hippotragini');
UM1_Hip_ref = UM1_ref(UM1_ref.tribe == 'Hippotragini',:);
save('UM1_Hippotragini_20210622.mat', 'UM1_Hip_teeth', 'UM1_Hip_ref');

%Neotragini
UM1_Neo_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Neotragini');
UM1_Neo_ref = UM1_ref(UM1_ref.tribe == 'Neotragini',:);
save('UM1_Neotragini_20210622.mat', 'UM1_Neo_teeth', 'UM1_Neo_ref');

%Reduncini
UM1_Red_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Reduncini');
UM1_Red_ref = UM1_ref(UM1_ref.tribe == 'Reduncini',:);
save('UM1_Reduncini_20210622.mat', 'UM1_Red_teeth', 'UM1_Red_ref');

%Tragelaphini
UM1_Tra_teeth = UM1_teeth(:,:,UM1_ref.tribe == 'Tragelaphini');
UM1_Tra_ref = UM1_ref(UM1_ref.tribe == 'Tragelaphini',:);
save('UM1_Tragelaphini_20210622.mat', 'UM1_Tra_teeth', 'UM1_Tra_ref');

%% UM2: split into tribes

%Alcelaphini
UM2_Alc_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Alcelaphini');
UM2_Alc_ref = UM2_ref(UM2_ref.tribe == 'Alcelaphini',:);
save('UM2_Alcelaphini_20210622.mat', 'UM2_Alc_teeth', 'UM2_Alc_ref');

%Antilopini 
UM2_Ant_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Antilopini');
UM2_Ant_ref = UM2_ref(UM2_ref.tribe == 'Antilopini',:);
save('UM2_Antilopini_20210622.mat', 'UM2_Ant_teeth', 'UM2_Ant_ref');

%Bovini
UM2_Bov_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Bovini');
UM2_Bov_ref = UM2_ref(UM2_ref.tribe == 'Bovini',:);
save('UM2_Bovini_20210622.mat', 'UM2_Bov_teeth', 'UM2_Bov_ref');

%Hippotragini
UM2_Hip_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Hippotragini');
UM2_Hip_ref = UM2_ref(UM2_ref.tribe == 'Hippotragini',:);
save('UM2_Hippotragini_20210622.mat', 'UM2_Hip_teeth', 'UM2_Hip_ref');

%Neotragini
UM2_Neo_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Neotragini');
UM2_Neo_ref = UM2_ref(UM2_ref.tribe == 'Neotragini',:);
save('UM2_Neotragini_20210622.mat', 'UM2_Neo_teeth', 'UM2_Neo_ref');

%Reduncini
UM2_Red_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Reduncini');
UM2_Red_ref = UM2_ref(UM2_ref.tribe == 'Reduncini',:);
save('UM2_Reduncini_20210622.mat', 'UM2_Red_teeth', 'UM2_Red_ref');

%Tragelaphini
UM2_Tra_teeth = UM2_teeth(:,:,UM2_ref.tribe == 'Tragelaphini');
UM2_Tra_ref = UM2_ref(UM2_ref.tribe == 'Tragelaphini',:);
save('UM2_Tragelaphini_20210622.mat', 'UM2_Tra_teeth', 'UM2_Tra_ref');

%% UM3: split into tribes

%Alcelaphini
UM3_Alc_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Alcelaphini');
UM3_Alc_ref = UM3_ref(UM3_ref.tribe == 'Alcelaphini',:);
save('UM3_Alcelaphini_20210622.mat', 'UM3_Alc_teeth', 'UM3_Alc_ref');

%Antilopini 
UM3_Ant_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Antilopini');
UM3_Ant_ref = UM3_ref(UM3_ref.tribe == 'Antilopini',:);
save('UM3_Antilopini_20210622.mat', 'UM3_Ant_teeth', 'UM3_Ant_ref');

%Bovini
UM3_Bov_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Bovini');
UM3_Bov_ref = UM3_ref(UM3_ref.tribe == 'Bovini',:);
save('UM3_Bovini_20210622.mat', 'UM3_Bov_teeth', 'UM3_Bov_ref');

%Hippotragini
UM3_Hip_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Hippotragini');
UM3_Hip_ref = UM3_ref(UM3_ref.tribe == 'Hippotragini',:);
save('UM3_Hippotragini_20210622.mat', 'UM3_Hip_teeth', 'UM3_Hip_ref');

%Neotragini
UM3_Neo_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Neotragini');
UM3_Neo_ref = UM3_ref(UM3_ref.tribe == 'Neotragini',:);
save('UM3_Neotragini_20210622.mat', 'UM3_Neo_teeth', 'UM3_Neo_ref');

%Reduncini
UM3_Red_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Reduncini');
UM3_Red_ref = UM3_ref(UM3_ref.tribe == 'Reduncini',:);
save('UM3_Reduncini_20210622.mat', 'UM3_Red_teeth', 'UM3_Red_ref');

%Tragelaphini
UM3_Tra_teeth = UM3_teeth(:,:,UM3_ref.tribe == 'Tragelaphini');
UM3_Tra_ref = UM3_ref(UM3_ref.tribe == 'Tragelaphini',:);
save('UM3_Tragelaphini_20210622.mat', 'UM3_Tra_teeth', 'UM3_Tra_ref');

