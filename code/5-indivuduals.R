

# geting individual teeth

toothtypes <- c("LM1", "LM2", "LM3", "UM1", "UM2", "UM3")
species <- c("scriptus", "pricei")

base_path <- "~/Documents/size/data/matlab/"
output_path <- "~/Documents/size/data/individuals/"

# Loop through each tooth type and species
for (tooth in toothtypes) {
  for (specie in species) {
    # Construct the file path for reading the CSV file
    input_file <- paste0(base_path, "data_", tooth, "_", specie, ".csv")
    
    # Read the CSV file
    data <- read.csv(input_file)
    
    # Calculate the number of files to be created based on rows
    num_files <- nrow(data) %/% 2
    
    # Loop through each pair of rows and write to a separate CSV file
    for (i in 1:num_files) {
      start_row <- (i - 1) * 2 + 1
      end_row <- start_row + 1
      
      # Subset the two rows
      data_subset <- data[start_row:end_row, ]
      
      # Define the file path
      file_name <- paste0(output_path, tooth, "_", specie, "/data_", tooth, "_", specie, "_", i, ".csv")
      
      # Write to CSV
      write.csv(data_subset, file = file_name, row.names = FALSE)
    }
  }
}
