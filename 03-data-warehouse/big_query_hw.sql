-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `dezoomcampnytaxi.external_yellowtaxi_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://dezoomcamp-kestra-bucket/yellow_tripdata_2019-*.csv', 'gs://dezoomcamp-kestra-bucket/yellow_tripdata_2020-*.csv']
);


-- Create a non partitioned table non clustered regular table from external table
CREATE OR REPLACE TABLE `dezoomcampnytaxi.regular_yellowtaxi_tripdata` 
AS
SELECT * FROM `dezoomcampnytaxi.external_yellowtaxi_tripdata`;


-- Question 1. Count of records for the 2024 Yellow Taxi Data
SELECT COUNT(*)
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`;


-- Question 2. Estimated amount of data
SELECT COUNT(DISTINCT(PULocationID))
FROM `dezoomcampnytaxi.external_yellowtaxi_tripdata`;

SELECT COUNT(DISTINCT(PULocationID))
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`;


-- Question 3. Why are the estimated number of Bytes different?
SELECT PULocationID
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`;

SELECT PULocationID, DOLocationID
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`;


-- Question 4. How many records have a fare_amount of 0?
SELECT COUNT(*)
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`
WHERE fare_amount = 0;


-- Question 5. The best strategy to make an optimized table in Big Query
CREATE OR REPLACE TABLE `dezoomcampnytaxi.yellowtaxi_tripdata_partitoned_clustered`
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID 
AS
SELECT * FROM `dezoomcampnytaxi.external_yellowtaxi_tripdata`;


-- Question 6. Estimated processed bytes
SELECT DISTINCT(VendorID)
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT(VendorID)
FROM `dezoomcampnytaxi.yellowtaxi_tripdata_partitoned_clustered`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';








--