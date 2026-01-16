Dlist <- list()
set.seed(20240521)
load("/Users/gregorymatthews/Dropbox/teeth-scriptus-pricei-size/data/teethdata_scriptus_pricei.RData")
pvals <- list()
for (toothtype in c("LM1","LM2","LM3","UM1","UM2","UM3")){print(toothtype)

n_scriptus <- length(data[[toothtype]][["scriptus"]])
n_pricei <- length(data[[toothtype]][["pricei"]])

class <- c(rep("scriptus",n_scriptus),rep("pricei",n_pricei))

#Run this script first in matlab: pairwise_dist_scriptus_pricei.m
#Pariwise distances
#First rows are scriptus and last rows are pricei
ddd <- read.csv(paste0("./data/matlab/pairwise_distances_",toothtype,".csv"), header = FALSE)
ddd <- as.matrix(ddd)

#Distrance based permutation testing.  
#Based on the test defined in Soto et al 2021
#1. Use distances based on the shapes projected into the tangent space.  
#to 2. Use distances in the size-shape space.  (I just need a function that computes distance between shapes tha tpreserves size.)


Dbar11 <- sum(ddd[class == "scriptus",class == "scriptus"])/(n_scriptus^2)
Dbar22 <- sum(ddd[class == "pricei",class == "pricei"])/(n_pricei^2)
Dbar12 <- sum(ddd[class == "pricei",class == "scriptus"])/(n_pricei*n_scriptus)

S <- ((n_scriptus*n_pricei)/((n_scriptus+n_pricei)))*(2*Dbar12 - (Dbar11 + Dbar22))

Dlist[[toothtype]] <- data.frame(toothtype, Dbar11, Dbar22, Dbar12)


#Now permute
Sperm <- c()
nsim <- 10
for (i in 1:nsim){print(i)
class_perm <- sample(class,length(class),replace = FALSE)
Dbar11 <- sum(ddd[class_perm == "scriptus",class_perm == "scriptus"])/(n_scriptus^2)
Dbar22 <- sum(ddd[class_perm == "pricei",class_perm == "pricei"])/(n_pricei^2)
Dbar12 <- sum(ddd[class_perm == "pricei",class_perm == "scriptus"])/(n_pricei*n_scriptus)

Sperm[i] <- ((n_scriptus*n_pricei)/((n_scriptus+n_pricei)))*(2*Dbar12 - (Dbar11 + Dbar22))
}

pvals[[toothtype]] <- mean(Sperm >= S)

hist(Sperm, main = toothtype, xlim = c(0, S + 5))
abline(v = S, col = "red")

}

unlist(pvals)


do.call(rbind,Dlist)



