
library(jpeg)
library(tidyverse)
library(dplyr)
library(Momocs)
library(fdasrvf)

data <- list()
for (i in c("LM1","LM2","LM3","UM1","UM2","UM3")){
  data[[i]] <- list()
  path <- paste0("/Users/nastaranghorbani/Documents/combined/data/",i,"/bw")
  file_list_BW_extant <- list.files(path, recursive = TRUE, full.names = TRUE)
  
  #Import the BW image files.
  start <- Sys.time()
  import_BW <- function(x){import_jpg(x)[[1]]}
  teeth_BW_train <- lapply(as.list(file_list_BW_extant), import_BW)
  names(teeth_BW_train) <- unlist(lapply(strsplit(file_list_BW_extant,"/"), function(x){x[[length(x)]]}))
  end <- Sys.time()
  end - start
  
  data[[i]][["combined"]] <- teeth_BW_train
  
  
  path <- paste0("/Users/nastaranghorbani/Documents/combined/data/",i,"/bw")
  file_list_BW_extant <- list.files(path, recursive = TRUE, full.names = TRUE)
  
  #Import the BW image files.
  start <- Sys.time()
  import_BW <- function(x){import_jpg(x)[[1]]}
  teeth_BW_train <- lapply(as.list(file_list_BW_extant), import_BW)
  names(teeth_BW_train) <- substring(file_list_BW_extant, unlist(gregexpr( "JPG",file_list_BW_extant)) - 9, unlist(gregexpr( "JPG",file_list_BW_extant)) - 2)
  end <- Sys.time()
  end - start
  
  data[[i]][["combined"]] <- teeth_BW_train
  
  
  
  
}



save(data, file = "/Users/nastaranghorbani/Documents/combined/teethdata_scriptus_pricei.RData")


make_same_num_points <- function(x, N = 500){
  out <- resamplecurve(t(x),N)
  return(out)
}

for (i in c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")) {
  data[[i]][["combined"]] <-
    lapply(data[[i]][["combined"]], make_same_num_points)
}




