### GeoTiff Experiment from GBIF data

**Exports were made from GBIF using the following.**

One degree
```sql
CREATE TABLE tim.one_deg ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' AS
SELECT 
  floor(decimalLatitude) AS lat,
  floor(decimalLongitude) AS lng,
  count(*) AS total
FROM 
  prod_a.occurrence_hdfs
WHERE
  hasGeospatialIssues = false AND 
  decimalLatitude is not null AND 
  decimalLongitude is not null AND
  year >= 2000
GROUP BY
  floor(decimalLatitude),
  floor(decimalLongitude)
```

0.5 degrees
```sql
CREATE TABLE tim.zero_five_deg ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' AS
SELECT 
  (floor(2 * decimalLatitude)) / 2 AS lat,
  (floor(2 * decimalLongitude)) / 2 AS lng,
  count(*) AS total
FROM 
  prod_a.occurrence_hdfs
WHERE
  hasGeospatialIssues = false AND 
  decimalLatitude is not null AND 
  decimalLongitude is not null AND
  year >= 2000
GROUP BY
  (floor(2 * decimalLatitude)) / 2,
  (floor(2 * decimalLongitude)) / 2
```

0.1 degrees
```sql
CREATE TABLE tim.zero_one_deg ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' AS
SELECT 
  round(decimalLatitude,1) AS lat,
  round(decimalLongitude,1) AS lng,
  count(*) AS total
FROM 
  prod_a.occurrence_hdfs
WHERE
  hasGeospatialIssues = false AND 
  decimalLatitude is not null AND 
  decimalLongitude is not null AND
  year >= 2000
GROUP BY
  round(decimalLatitude,1),
  round(decimalLongitude,1)
```

0.01 degrees
```sql
CREATE TABLE tim.zero_zero_one_deg ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' AS
SELECT 
  round(decimalLatitude,2) AS lat,
  round(decimalLongitude,2) AS lng,
  count(*) AS total
FROM 
  prod_a.occurrence_hdfs
WHERE
  hasGeospatialIssues = false AND 
  decimalLatitude is not null AND 
  decimalLongitude is not null AND
  year >= 2000
GROUP BY
  round(decimalLatitude,2),
  round(decimalLongitude,2)
```
**CSV files were converted to geo-tifs using the R code**

```r
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
```
