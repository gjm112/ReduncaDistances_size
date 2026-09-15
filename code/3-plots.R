library(tidyverse)
library(vegan)

# ------------------------------------------------------------
# Try every possible starting point and return the best
# Procrustes alignment
# ------------------------------------------------------------

best_procrustes <- function(temp, reference, scale = FALSE) {
  
  temp <- as.matrix(temp)
  reference <- as.matrix(reference)
  
  n <- nrow(temp)
  
  if (n != nrow(reference)) {
    stop("Shapes must have the same number of points")
  }
  
  results <- vector("list", n)
  
  for (i in 1:n) {
    
    # Cyclically shift temp so point i becomes point 1
    if (i ==1){temp_shift <- temp}
    if (i != 1){temp_shift <- temp[c(i:n, 1:(i - 1)), , drop = FALSE]}
    
    # Procrustes alignment
    rot <- vegan::procrustes(
      reference,
      temp_shift,
      scale = FALSE
    )
    
    results[[i]] <- list(
      start = i,
      ss = rot$ss,
      rotation = rot
    )
  }
  
  # Find the starting point producing the smallest SS
  best <- which.min(sapply(results, function(x) x$ss))
  
  results[[best]]
}



dat <- data.frame()
toothtype <- c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")
species <- c("arundinum","darti", "combined")

for (t in toothtype) {
  for (s in species) {
    temp <-t(read.csv(paste0("data/matlab/out_beta_", t, "_", s, ".csv"),
                 header = FALSE))
    temp_combined  <- t(read.csv(paste0("data/matlab/out_beta_", t, "_combined.csv"),
                                 header = FALSE))
    
    #Quick and dirty Procrustes for visualization
    rot <- best_procrustes(temp,temp_combined, scale = FALSE)
    
    dat <- rbind(dat,data.frame(toothtype = t, species = s, x = rot$rotation$Yrot[,1],y = rot$rotation$Yrot[,2]))
    
  }
}

dat <- dat %>% mutate(toothtype_char = substring(toothtype,1,2), toothtype_num = substring(toothtype,3,3))

rotation_matrix_2d <- function(angle, degrees = TRUE) {
  if (degrees) {
    angle <- angle * pi / 180
  }
  
  # Create the matrix elements
  matrix(c(cos(angle), sin(angle), -sin(angle), cos(angle)), 
         nrow = 2, ncol = 2)
}

# Example: Generate a 90-degree rotation matrix
R <- rotation_matrix_2d(180)

#Manual rotation
dat[dat$toothtype == "UM2" & dat$species == "darti",c("x","y")] <- dat %>% filter(toothtype == "UM2" & species == "darti") %>% select(x,y) %>% as.matrix() %*% R
dat[dat$toothtype == "UM3" & dat$species == "darti",c("x","y")] <- dat %>% filter(toothtype == "UM3" & species == "darti") %>% select(x,y) %>% as.matrix() %*% R

R <- rotation_matrix_2d(270)
dat[dat$toothtype == "UM1" & dat$species == "darti",c("x","y")] <- dat %>% filter(toothtype == "UM1" & species == "darti") %>% select(x,y) %>% as.matrix() %*% R



png("./mean-size-and-shapes.png", res = 300, units = "in", h = 6, w = 10)
ggplot(aes(x = x, y = y, col = species), data = dat) + geom_path() + facet_grid(toothtype_num ~ toothtype_char) + theme_bw()  + coord_fixed() +  
  scale_x_continuous(breaks = c(-20*300/25.4,-10*300/25.4,0,10*300/25.4,20*300/25.4), labels = c(-20,-10,0,10,20)) + xlab("x (mm)") + 
  scale_y_continuous(breaks = c(-20*300/25.4,-10*300/25.4,0,10*300/25.4,20*300/25.4), labels = c(-20,-10,0,10,20)) + ylab("y (mm)")
dev.off()

