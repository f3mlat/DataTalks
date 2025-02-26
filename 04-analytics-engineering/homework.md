## SETUP

The datasets can be found [here](./images/datasets_in_gcs.png) <br/>

Here are the tables and number of records:
* Green Taxi table shown [here](./images/green_taxi_records_bq.png) <br/>
* Yellow Taxi table shown [here](./images/yellow_taxi_records_bq.png) <br/>
* FHV table shown [here](./images/fhv_records_bq.png) <br/>

The screenshot of the staging models, dimensions, and facts in GCP can be found [here](./images/data_objects_bq.png) <br/>


## Question 1
The sources.yaml file as provided can be found [here](./sources.yml)<br/>
The screenshot for the env variables setup where dbt runs can be found [here](./images/hw4_q1_1.png)<br/>
The sql file with the provided script can be found [here](./ext_green_taxi.sql)<br/>

After running `dbt build`, the resulting compiled sql file can be found [here](./ext_green_taxi_compiled.sql)

Answer: **select * from myproject.raw_nyc_tripdata.ext_green_taxi**

## Question 2
Setting up the DAYS_BACK ENV_VAR to -15 can be seen in the screenshot [here](./images/hw4_q2_1.png)<br/>
Using the provided snippet with the WHERE clause updated to option 4, the dbt_model fact_recent_taxi_trips file can be found [here](./fact_recent_taxi_trips.sql)<br/>

* Compiling the dbt_model fact_recent_taxi_trips with the command line argument days_back set to -7 can be seen [here](./images/hw4_q2_2.png)<br/>
The script generated can be found [here](./fact_recent_taxi_trips_compiled_using_cmd_line_args.sql)
* Compiling the dbt_model fact_recent_taxi_trips without setting command line argument days_back<br/>
The script generated can be found [here](./fact_recent_taxi_trips_compiled_without_cmd_line_args.sql)
* Compiling the dbt_model fact_recent_taxi_trips without setting command line argument days_back and ENV_VAR DAYS_BACK<br/>
The script generated can be found [here](./fact_recent_taxi_trips_compiled_without_command_line_args_and_env_vars.sql)
and
Answer: **Update the WHERE clause to `pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY`**

## Question 3
SQL query to retrieve the PULocationID from the table (not the external table) in BigQuery:<br/>
```
SELECT PULocationID
FROM `dezoomcamp2025-449018.dezoomcampnytaxi.regular_yellowtaxi_tripdata`;
```
SQL query to retrieve the PULocationID and DOLocationID on the same table:<br/>
```
SELECT PULocationID, DOLocationID
FROM `dezoomcamp2025-449018.dezoomcampnytaxi.regular_yellowtaxi_tripdata`;
```
Answer: **BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires 
reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.**


## Question 4
SQL query to count the number of records having a fare_amount of 0:
```
SELECT COUNT(*)
FROM `dezoomcamp2025-449018.dezoomcampnytaxi.regular_yellowtaxi_tripdata`
WHERE fare_amount = 0;
```
The result can be seen in the screenshot below:<br/>
![0_fare_amount_count](./images/question4.png)

Answer: **8333**

## Question 5
SQL query to create new table with the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID:<br/>
```
CREATE OR REPLACE TABLE `dezoomcamp2025-449018.dezoomcampnytaxi.yellowtaxi_tripdata_partitoned_clustered`
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID 
AS
SELECT * FROM `dezoomcamp2025-449018.dezoomcampnytaxi.external_yellowtaxi_tripdata`;
```
Answer: **Partition by tpep_dropoff_datetime and Cluster on VendorID**


## Question 6
SQL query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive):</br>
**Using the materialized table**<br/>
```
SELECT DISTINCT(VendorID)
FROM `dezoomcamp2025-449018.dezoomcampnytaxi.regular_yellowtaxi_tripdata`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
```
**Using the partitioned table**<br/>
```
SELECT DISTINCT(VendorID)
FROM `dezoomcamp2025-449018.dezoomcampnytaxi.yellowtaxi_tripdata_partitoned_clustered`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
```
The estimated amounts are shown in the screenshots below:<br/>
![estimated_amount](./images/question6_1.png)

![estimated_amount](./images/question6_2.png)

Answer: **310.24 MB for non-partitioned table and 26.84 MB for the partitioned table**

## (Bonus: Not worth points) Question 9:
SQL query to count all records in materialized table:
```
SELECT COUNT(*)
FROM `dezoomcamp2025-449018.dezoomcampnytaxi.regular_yellowtaxi_tripdata`
```
The estimated amount is shown in the screenshot below:<br/>
![estimated_amount](./images/question9.png)
Answer: **0B**
