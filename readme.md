### GeoTiff Experiment from GBIF data

Exports were made from GBIF using the following.

One degree
```
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
```
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
```
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
```
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
