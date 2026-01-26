#Dlist <- list()
set.seed(20240521)
load("./data/teethdata_darti_arundinum_fulvorfula.RData")
pvals <- list()
for (toothtype in c("LM1","LM2","LM3","UM1","UM2","UM3")){print(toothtype)
  
pvals[[toothtype]] <- c()
n_darti <- length(data[[toothtype]][["darti"]])
n_arundinum <- length(data[[toothtype]][["arundinum"]])
n_fulvorufula <- length(data[[toothtype]][["fulvorufula"]])

class <- c(rep("darti",n_darti),
           rep("arundinum",n_arundinum),
           rep("fulvorufula",n_fulvorufula))


#Run this script first in matlab: pairwise_dist_scriptus_pricei.m
#Pariwise distances
#First rows are scriptus and last rows are pricei
ddd <- read.csv(paste0("./data/matlab/pairwise_distances_",toothtype,".csv"), header = FALSE)
ddd <- as.matrix(ddd)

#Distrance based permutation testing.  
#Based on the test defined in Soto et al 2021
#1. Use distances based on the shapes projected into the tangent space.  
#to 2. Use distances in the size-shape space.  (I just need a function that computes distance between shapes tha tpreserves size.)


##########################################
#darti vs arundinum
##########################################
Dbar11 <- sum(ddd[class == "darti",class == "darti"])/(n_darti^2)
Dbar22 <- sum(ddd[class == "arundinum",class == "arundinum"])/(n_arundinum^2)
Dbar12 <- sum(ddd[class == "darti",class == "arundinum"])/(n_darti*n_arundinum)

S <- ((n_darti*n_arundinum)/((n_darti+n_arundinum)))*(2*Dbar12 - (Dbar11 + Dbar22))

#Now permute
Sperm <- c()
nsim <- 10000
for (i in 1:nsim){
  class_sub <- class[class %in% c("darti","arundinum")]
  class_perm <- sample(class_sub,length(class_sub),replace = FALSE)
  Dbar11 <- sum(ddd[class_perm == "darti",class_perm == "darti"])/(n_darti^2)
  Dbar22 <- sum(ddd[class_perm == "arundinum",class_perm == "arundinum"])/(n_arundinum^2)
  Dbar12 <- sum(ddd[class_perm == "darti",class_perm == "arundinum"])/(n_darti*n_arundinum)
  
  Sperm[i] <- ((n_darti*n_arundinum)/((n_darti+n_arundinum)))*(2*Dbar12 - (Dbar11 + Dbar22))
}

pvals[[toothtype]]["darti_arundinum"] <- mean(Sperm >= S)

# hist(Sperm, main = toothtype, xlim = c(0, S + .05))
# abline(v = S, col = "red")


##########################################
#darti vs fulvorufula
##########################################
Dbar11 <- sum(ddd[class == "darti",class == "darti"])/(n_darti^2)
Dbar22 <- sum(ddd[class == "fulvorufula",class == "fulvorufula"])/(n_fulvorufula^2)
Dbar12 <- sum(ddd[class == "darti",class == "fulvorufula"])/(n_darti*n_fulvorufula)

S <- ((n_darti*n_fulvorufula)/((n_darti+n_fulvorufula)))*(2*Dbar12 - (Dbar11 + Dbar22))

#Now permute
Sperm <- c()
nsim <- 10000
for (i in 1:nsim){
  class_sub <- class[class %in% c("darti","fulvorufula")]
  class_perm <- sample(class_sub,length(class_sub),replace = FALSE)
  Dbar11 <- sum(ddd[class_perm == "darti",class_perm == "darti"])/(n_darti^2)
  Dbar22 <- sum(ddd[class_perm == "fulvorufula",class_perm == "fulvorufula"])/(n_fulvorufula^2)
  Dbar12 <- sum(ddd[class_perm == "darti",class_perm == "fulvorufula"])/(n_darti*n_fulvorufula)
  
  Sperm[i] <- ((n_darti*n_fulvorufula)/((n_darti+n_fulvorufula)))*(2*Dbar12 - (Dbar11 + Dbar22))
}

pvals[[toothtype]]["darti_fulvorufula"] <- mean(Sperm >= S)


}

p.adjust(unlist(pvals),"fdr") 

out <- data.frame(toothtpye = rep(c("LM1","LM2","LM3","UM1","UM2","UM3"),each = 2),
                  comparison = rep(c("darti_arundinum","darti_fulvorufula"),6),
                  raw_pvalue = unlist(pvals),
                  adjusted_pvalue = p.adjust(unlist(pvals),"fdr"))
write.csv(out, file = "./results/pvalues_size_and_shape_only.csv", row.names = FALSE)






