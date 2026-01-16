
# run teeth_scriptus_pricei_find-mean_combined.m in matlab

#This is the same data for shape and size and shape
#I'm only using this to get countshere
load("/Users/gregorymatthews/Dropbox/teeth-scriptus-pricei/data/teethdata_scriptus_pricei.RData")
#Scriptus is the first n rows, pricei is the last some rows. 
length(data[["LM1"]][["scriptus"]])
length(data[["LM1"]][["pricei"]])


pvals_hotelling = list()
for (i in c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")){
  


PC_combined <- read.csv(paste0("./data/matlab/PC_feat_",i,"_combined.csv"), header = FALSE)

library(Hotelling)
PC_combined$g <- c(rep(1,length(data[[i]][["scriptus"]])),
                           rep(2,length(data[[i]][["pricei"]])))


results <-  hotelling.test(.~g, data = PC_combined)
results$stats$statistic
#results <-  hotelling.stat(PC_LM1_combined[PC_LM1_combined$g ==1,-11],PC_LM1_combined[PC_LM1_combined$g ==2,-11])
#results$statistic

#Permutation
nsim <- 1000
null <- c()
for (j in 1:nsim){
temp <- PC_combined
temp$g <- sample(temp$g, length(temp$g),replace = FALSE)
null[j] <-  hotelling.test(.~g, data = temp)$stat$statistic
}


pvals_hotelling[[i]] <- mean(null >= results$stats$statistic)
}

unlist(pvals_hotelling)







