


# run teeth_scriptus_pricei_find-mean_combined.m in matlab


load("/Users/nastaranghorbani/Documents/size/data/teethdata_scriptus_pricei.RData")
#Scriptus is the first n rows, pricei is the last some rows. 
length(data[["LM1"]][["scriptus"]])
length(data[["LM1"]][["pricei"]])


pvals_hotelling = list()
pvals_permutation = list()
for (i in c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")){
  
  
  
  PC_combined <- read.csv(paste0("/Users/nastaranghorbani/Documents/size/data/matlab/PC_feat_",i,"_combined.csv"), header = FALSE)
  
  library(Hotelling)
  PC_combined$g <- c(rep(1,length(data[[i]][["scriptus"]])),
                     rep(2,length(data[[i]][["pricei"]])))
  
  results <-  hotelling.test(.~g, data = PC_combined)
  pvals_hotelling[[i]] <- results$pval  # p-value from Hotelling's test
  
  #results$stats$statistic
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
  
  pvals_permutation[[i]] <- mean(null >= results$stat$statistic)
}


print(pvals_hotelling)
print(pvals_permutation)






####################
load("/Users/nastaranghorbani/Documents/size/data/teethdata_scriptus_pricei.RData")
pvals <- list()
for (toothtype in c("LM1","LM2","LM3","UM1","UM2","UM3")){print(toothtype)
  
  n_scriptus <- length(data[[toothtype]][["scriptus"]])
  n_pricei <- length(data[[toothtype]][["pricei"]])
  
  class <- c(rep("scriptus",n_scriptus),rep("pricei",n_pricei))
  
  
  #Run this script first in matlab: pairwise_dist_scriptus_pricei.m
  #Pariwise distances
  #First rows are scriptus and last rows are pricei
  ddd <- read.csv(paste0("/Users/nastaranghorbani/Documents/size/data/matlab/pairwise_distances_",toothtype,".csv"), header = FALSE)
  ddd <- as.matrix(ddd)
  
  #Distrance based permutation testing.  
  #Based on the test defined in Soto et al 2021
  #1. Use distances based on the shapes projected into the tangent space.  
  #to 2. Use distances in the size-shape space.  (I just need a function that computes distance between shapes tha tpreserves size.)
  
  
  Dbar11 <- sum(ddd[class == "scriptus",class == "scriptus"])/(n_scriptus^2)
  Dbar22 <- sum(ddd[class == "pricei",class == "pricei"])/(n_pricei^2)
  Dbar12 <- sum(ddd[class == "pricei",class == "scriptus"])/(n_pricei*n_pricei)
  
  S <- ((n_scriptus*n_pricei)/((n_scriptus+n_pricei)))*(2*Dbar12 - (Dbar11 + Dbar22))
  
  #Now permute
  Sperm <- c()
  nsim <- 100000
  for (i in 1:nsim){print(i)
    class_perm <- sample(class,length(class),replace = FALSE)
    Dbar11 <- sum(ddd[class_perm == "scriptus",class_perm == "scriptus"])/(n_scriptus^2)
    Dbar22 <- sum(ddd[class_perm == "pricei",class_perm == "pricei"])/(n_pricei^2)
    Dbar12 <- sum(ddd[class_perm == "pricei",class_perm == "scriptus"])/(n_pricei*n_pricei)
    
    Sperm[i] <- ((n_scriptus*n_pricei)/((n_scriptus+n_pricei)))*(2*Dbar12 - (Dbar11 + Dbar22))
  }
  
  pvals[[toothtype]] <- mean(Sperm >= S)
  
}





# # # # # # # 

#pvals_hotelling
#pvals_permutation
#pvals
##############



results_table <- data.frame(
  Toothtype = c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3"),
  Hotelling = numeric(6), # Placeholder vector for Hotelling p-values
  Permutation = numeric(6), # Placeholder vector for Permutation p-values
  Distance = numeric(6), # Placeholder vector for Distance p-values
  stringsAsFactors = FALSE
)

# Fill in the p-values for each tooth type and method
results_table$Hotelling <- c(pvals_hotelling[['LM1']], pvals_hotelling[['LM2']], pvals_hotelling[['LM3']],
                             pvals_hotelling[['UM1']], pvals_hotelling[['UM2']], pvals_hotelling[['UM3']])

results_table$Permutation <- c(pvals_permutation[['LM1']], pvals_permutation[['LM2']], pvals_permutation[['LM3']],
                               pvals_permutation[['UM1']], pvals_permutation[['UM2']], pvals_permutation[['UM3']])

results_table$Distance <- c(pvals[['LM1']], pvals[['LM2']], pvals[['LM3']],
                            pvals[['UM1']], pvals[['UM2']], pvals[['UM3']])

# View the results in a table
View(results_table)

# Write the table to a CSV file
#write.csv(results_table, "/Users/nastaranghorbani/Documents/size/data/results_table_summary.csv", row.names = FALSE, quote = FALSE)

##################################




# Length Tables


load("/Users/nastaranghorbani/Documents/size/data/teethdata_scriptus_pricei.RData")
length(data[["LM1"]][["scriptus"]])
length(data[["LM1"]][["pricei"]])




# Define the variables of interest
variables <- c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")

# Initialize an empty data frame to store the results
lengths_table <- data.frame(Variable = character(),
                            ScriptusLength = integer(),
                            PriceiLength = integer(),
                            stringsAsFactors = FALSE)

# Loop through each variable and add the lengths to the table
for (var in variables) {
  scriptus_length <- length(data[[var]][["scriptus"]])
  pricei_length <- length(data[[var]][["pricei"]])
  lengths_table <- rbind(lengths_table, data.frame(Variable = var,
                                                   ScriptusLength = scriptus_length,
                                                   PriceiLength = pricei_length))
}

print(lengths_table)

View(lengths_table)



