dat <- data.frame()
library(tidyverse)
load("/Users/gregorymatthews/Dropbox/teeth-scriptus-pricei/data/teethdata_scriptus_pricei.RData")

for (toothtype in c("LM1","LM2","LM3","UM1","UM2","UM3")){print(toothtype)

  n_scriptus <- length(data[[toothtype]][["scriptus"]])
  n_pricei <- length(data[[toothtype]][["pricei"]])
  
  class <- c(rep("scriptus",n_scriptus),rep("pricei",n_pricei))
  

ddd <- read.csv(paste0("./data/matlab/pairwise_distances_",toothtype,".csv"), header = FALSE)
ddd <- as.matrix(ddd)

row.names(ddd) <- class
colnames(ddd) <- class

mds <- cmdscale(ddd)
dat <- dat %>% bind_rows(data.frame(toothtype = toothtype , species = class, x = mds[,1], y = mds[,2]))

}

dat <- dat %>% mutate(upperlower = substring(toothtype,1,1), toothnum = substring(toothtype,3,3))
dat$upperlower <- factor(dat$upperlower, levels = c("U","L"))

png("./mds_size_and_shape.png", res = 300, unit = "in", w = 8, h = 5)
ggplot(aes(x = x, y = y, color = species), data = dat) + geom_point(alpha = 0.75) + theme_bw() + facet_grid(upperlower ~ toothnum) + xlab("") + ylab("")
dev.off()





