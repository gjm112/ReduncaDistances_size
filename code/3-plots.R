library(tidyverse)
dat <- data.frame()
toothtype <- c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")
species <- c("pricei", "scriptus", "combined")
for (t in toothtype) {
  for (s in species) {
    temp <-
      t(read.csv(paste0("data/matlab/out_betanew_", t, "_", s, ".csv"),
                 header = FALSE))
    dat <- rbind(dat,data.frame(toothtype = t, species = s, x = temp[,1],y = temp[,2]))
    
  }
}

dat <- dat %>% mutate(toothtype_char = substring(toothtype,1,2), toothtype_num = substring(toothtype,3,3))

png("./mean-size-and-shapes.png", res = 300, units = "in", h = 6, w = 10)
ggplot(aes(x = x, y = y, col = species), data = dat) + geom_path() + facet_grid(toothtype_num ~ toothtype_char) + theme_bw()
dev.off()

