# Convert the long format csvs into geotiff to be used in spatial analyses
# eg in ArcGIS
# Tom August
library(raster)

# Write a function to do the conversion
csv_to_geotiff <- function(csv_name){
  csv <- read.csv(unz(csv_name, gsub(".zip$","", csv_name)), header = FALSE)
  names(csv) <- c('Lat', 'Long', 'Number')
  
  r <- rasterFromXYZ(csv[,c(2,1,3)], crs = CRS("+init=epsg:4326"))
  
  writeRaster(r, filename = gsub('.csv.zip', '', csv_name),
              format = "GTiff", overwrite = TRUE)
  return(r)
}

# Apply to all the csvs
csvs <- list.files(pattern = '.zip$')
rs <- lapply(csvs, csv_to_geotiff)