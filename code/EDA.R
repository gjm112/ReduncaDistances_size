library(jpeg)
library(tidyverse)
library(dplyr)
library(Momocs)
#library(fdasrvf)


data <- list()
for (i in c("LM1","LM2","LM3","UM1","UM2","UM3")){
  data[[i]] <- list()
  path <- paste0("/Users/gregorymatthews/Dropbox/teeth-scriptus-pricei/data/pricei_bw/images/Fossil/Tragelaphini/Tragelaphus/pricei/",i,"/bw")
  file_list_BW_extant <- list.files(path, recursive = TRUE, full.names = TRUE)
  
  #Import the BW image files.
  start <- Sys.time()
  import_BW <- function(x){import_jpg(x)[[1]]}
  teeth_BW_train <- lapply(as.list(file_list_BW_extant), import_BW)
  names(teeth_BW_train) <- substring(file_list_BW_extant, unlist(gregexpr( "JPG",file_list_BW_extant)) - 9, unlist(gregexpr( "JPG",file_list_BW_extant)) - 2)
  end <- Sys.time()
  end - start
  
  data[[i]][["pricei"]] <- teeth_BW_train
  
}






