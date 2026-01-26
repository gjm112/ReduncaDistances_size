set.seed(20251208)
library(jpeg)
library(tidyverse)
library(dplyr)
library(Momocs)
library(fdasrvf)

data <- list()
for (i in c("LM1","LM2","LM3","UM1","UM2","UM3")){
  data[[i]] <- list()
  
  ###########
  #darti
  ###########
  path <- paste0("./data/images/Fossil/Reduncini/Redunca/darti/",i,"/bw")
  file_list_BW_darti_fossil <- list.files(path, recursive = TRUE, full.names = TRUE)
  
  #Import the BW image files.
  start <- Sys.time()
  import_BW <- function(x){import_jpg(x)[[1]]}
  teeth_BW_train_darti_fossil <- lapply(as.list(file_list_BW_darti_fossil), import_BW)
  names(teeth_BW_train_darti_fossil) <- unlist(lapply(strsplit(file_list_BW_darti_fossil,"/"), function(x){x[[length(x)]]}))
  names(teeth_BW_train_darti_fossil) <- substring(names(teeth_BW_train_darti_fossil),1,nchar(names(teeth_BW_train_darti_fossil))-4)
  end <- Sys.time()
  end - start
  
  data[[i]][["darti"]] <- teeth_BW_train_darti_fossil
  
  ###########
  #arundinum
  ###########  
  path <- paste0("./data/images/Extant/Reduncini/Redunca/arundinum/",i,"/bw")
  file_list_BW_arundinum_extant <- list.files(path, recursive = TRUE, full.names = TRUE)
  
  #Import the BW image files.
  start <- Sys.time()
  import_BW <- function(x){import_jpg(x)[[1]]}
  teeth_BW_train_arundinum_extant <- lapply(as.list(file_list_BW_arundinum_extant), import_BW)
  names(teeth_BW_train_arundinum_extant) <- unlist(lapply(strsplit(file_list_BW_arundinum_extant,"/"), function(x){x[[length(x)]]}))
  names(teeth_BW_train_arundinum_extant) <- substring(names(teeth_BW_train_arundinum_extant),1,nchar(names(teeth_BW_train_arundinum_extant))-4)
  end <- Sys.time()
  end - start
  
  data[[i]][["arundinum"]] <- teeth_BW_train_arundinum_extant
  
  ###########
  #fulvorufula
  ###########    
  path <- paste0("./data/images/Extant/Reduncini/Redunca/fulvorufula/",i,"/bw")
  file_list_BW_fulvorufula_extant <- list.files(path, recursive = TRUE, full.names = TRUE)
  
  #Import the BW image files.
  start <- Sys.time()
  import_BW <- function(x){import_jpg(x)[[1]]}
  teeth_BW_train_fulvorufula_extant <- lapply(as.list(file_list_BW_fulvorufula_extant), import_BW)
  names(teeth_BW_train_fulvorufula_extant) <- unlist(lapply(strsplit(file_list_BW_fulvorufula_extant,"/"), function(x){x[[length(x)]]}))
  names(teeth_BW_train_fulvorufula_extant) <- substring(names(teeth_BW_train_fulvorufula_extant),1,nchar(names(teeth_BW_train_fulvorufula_extant))-4)
  end <- Sys.time()
  end - start
  
  data[[i]][["fulvorufula"]] <- teeth_BW_train_fulvorufula_extant
  
}




#Manual fixes:
#Check if any teeth are counter clockwise
#All teeth should fo clock wise.  These two are going COUNTER clockwise.  Reverse them:
#These teeth go counterclockwise.  
#They need to be corrected to go clockwise
#LM1  num 15: DSCN0680 

#LM2 num 48 and 70
#DSCN3442
#DSCN4351

#LM3 num 42
#DSCN0986

#UM2 num 71 
#DSCN6138

#Manual corrections
# data[["LM1"]][["darti"]][["DSCN0680"]] <- data[["LM1"]][["darti"]][["DSCN0680"]][nrow(data[["LM1"]][["darti"]][["DSCN0680"]]):1,]
# data[["LM2"]][["arundinum"]][["DSCN3442"]] <- data[["LM2"]][["arundinum"]][["DSCN3442"]][nrow(data[["LM2"]][["arundinum"]][["DSCN3442"]]):1,]
# data[["LM2"]][["fulvorufula"]][["DSCN4351"]] <- data[["LM2"]][["fulvorufula"]][["DSCN4351"]][nrow(data[["LM2"]][["fulvorufula"]][["DSCN4351"]]):1,]
# data[["LM3"]][["darti"]][["DSCN0986"]] <- data[["LM3"]][["darti"]][["DSCN0986"]][nrow(data[["LM3"]][["darti"]][["DSCN0986"]]):1,]
# data[["UM2"]][["fulvorufula"]][["DSCN6138"]] <- data[["UM2"]][["fulvorufula"]][["DSCN6138"]][nrow(data[["UM2"]][["fulvorufula"]][["DSCN6138"]]):1,]
#Save the list
save(data, file = "./data/teethdata_arundinum_darti_fulvorufula.RData")


#Now do data prep for matlab
#Makes all the teeth have the same number of points
make_same_num_points <- function(x, N = 500){
  out <- resamplecurve(t(x),N)
  return(out)
}

for (i in c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")) {
  data[[i]][["darti"]] <-
    lapply(data[[i]][["darti"]], make_same_num_points)
  data[[i]][["arundinum"]] <-
    lapply(data[[i]][["arundinum"]], make_same_num_points)
  data[[i]][["fulvorufula"]] <-
    lapply(data[[i]][["fulvorufula"]], make_same_num_points)
}




data_for_matlab <- list()
for (i in c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")) {print(i)
  data_for_matlab[[i]] <- list()
  data_for_matlab[[i]][["darti"]] <- do.call(rbind,data[[i]][["darti"]])
  data_for_matlab[[i]][["arundinum"]] <- do.call(rbind,data[[i]][["arundinum"]])
  data_for_matlab[[i]][["fulvorufula"]] <- do.call(rbind,data[[i]][["fulvorufula"]])
}



for (i in c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")) {print(i)
  write.csv(data_for_matlab[[i]][["darti"]],file = paste0("./data/matlab/data_",i,"_darti.csv"), row.names = FALSE)
  write.csv(data_for_matlab[[i]][["arundinum"]],file = paste0("./data/matlab/data_",i,"_arundinum.csv"), row.names = FALSE)
  write.csv(data_for_matlab[[i]][["fulvorufula"]],file = paste0("./data/matlab/data_",i,"_fulvorufula.csv"), row.names = FALSE)
}

save(data, file = "./data/teethdata_darti_arundinum_fulvorfula.RData")
load("./data/teethdata_darti_arundinum_fulvorfula.RData")
for (toothtype in c("LM1","LM2","LM3","UM1","UM2","UM3")){print(toothtype)
  
  
  labels <- data.frame(ID = c(names(data[[toothtype]][["darti"]]),
                              names(data[[toothtype]][["arundinum"]]),
                              names(data[[toothtype]][["fulvorufula"]])), 
                       species = c(rep("darti",length(data[[toothtype]][["darti"]])),
                                   rep("arundinum",length(data[[toothtype]][["arundinum"]])),
                                   rep("fulvorufula",length(data[[toothtype]][["fulvorufula"]]))))
  
  #Run this script first in matlab: pairwise_dist_scriptus_pricei.m
  #Pariwise distances
  #First rows are scriptus and last rows are pricei
  ddd <- read.csv(paste0("./data/matlab/pairwise_distances_",toothtype,".csv"), header = FALSE)
  ddd <- as.matrix(ddd)
  
  forgg <- cbind(labels,cmdscale(ddd))
  forgg <- forgg %>% rename(x = `1`, y = `2`)
  forgg %>% ggplot(aes(x = x, y = y, color = species)) + geom_point() + theme_bw()
  
}

image(ddd)