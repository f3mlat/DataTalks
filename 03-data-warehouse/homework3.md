The download of the parquet files and upload to my GCS bucket was carried out using the linked script [here](./load_yellow_taxi_data.py):<br>
The screenshot of the downloaded files is below:<br/>
![6_parquet_files](./images/parquet_files_in_gcp_bucket.png)

BIG QUERY SETUP queries</br>
Create an external table using the Yellow Taxi Trip Records. </br>
```
CREATE OR REPLACE EXTERNAL TABLE `dezoomcamp2025-449018.dezoomcampnytaxi.external_yellowtaxi_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://dezoomcamp-kestra-bucket/yellow_tripdata_2019-*.csv', 'gs://dezoomcamp-kestra-bucket/yellow_tripdata_2020-*.csv']
);
```
Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table). </br>
```
CREATE OR REPLACE TABLE `dezoomcamp2025-449018.dezoomcampnytaxi.regular_yellowtaxi_tripdata` 
AS
SELECT * FROM `dezoomcampnytaxi.external_yellowtaxi_tripdata`;
```

## Question 1
SQL query for the count of records for the 2024 Yellow Taxi Data is below:
```
SELECT COUNT(*)
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`;
```
Checkout the result in below screenshot:<br/>
![record_count](./images/question1.png)

Answer: 20332093

## Question 2
SQL query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br>
```
SELECT COUNT(DISTINCT(PULocationID))
FROM `dezoomcampnytaxi.external_yellowtaxi_tripdata`;

SELECT COUNT(DISTINCT(PULocationID))
FROM `dezoomcampnytaxi.regular_yellowtaxi_tripdata`;
```

The estimated amount it shown in the screenshots below:
![estimated_amount](./images/question2_1.png)

![estimated_amount](./images/question2_2.png)



Answer: green_tripdata_2020-04.csv


## Question 3
Executed the flow [here](./flows/02_postgres_taxi_scheduled.yaml) for Yellow taxi and configuring the backfill extensions in the Trigger tab.

This is shown in the image below

![homework datasets](./images/question3.png)


## Question 4
Executed the flow [here](./flows/02_postgres_taxi_scheduled.yaml) for Green taxi and configuring the backfill extensions in the Trigger tab.

This is shown in the image below

![homework datasets](./images/question4.png)

## Question 5
Modified the flow that listed just years 2019 and 2020 to include 2021. The modified file can be found  [here](./flows/02_postgres_taxi_all_years.yaml).

Executed the flow selecting Green taxi, year 2021 and month 03. This is shown in the image below.

![homework datasets](./images/question5.png)


## Question 6
Timezone configuration to New York was achieved by adding a timezone property set to America/New_York in the Schedule trigger configuration.

The modified file can be found  [here](./flows/02_postgres_taxi_scheduled_with_newyork_time.yaml).

This is shown in the image below

![homework datasets](./images/question6.png)
