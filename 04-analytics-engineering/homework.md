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

Answer: **Update the WHERE clause to `pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY`**

## Question 3
Doing a `dbt run` to materialize fact_taxi_monthly_zone_revenue was successful in all cases except for option 2<br/>
The error message can be found in the screenshot [here](./images/hw4_q3_1.png)

Answer: **dbt run --select +models/core/dim_taxi_trips.sql+ --target prod**

## Question 4
After setting up the macro and running `dbt run`, the result is shown in this screenshot [here](./images/hw4_q4_1.png)<br/>

For the options below, the env vars are appended to the dataset configured in profiles.yml
* When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET<br/>
* When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET<br/>
* When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET<br/>

Answer: **Setting a value for  DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile**

<br/><br/>

For Question 5 to 7, the models where created:
* [Date dimension](./dim_date.sql)
* [Zone Look dimension](./dim_zone_lookuo.sql)
* [Taxi trips fact](./fact_taxi_trips.sql)
* [Taxi trips quarterly revenue](./fact_taxi_trips_quarterly_revenue.sql)
* [Taxi trips monthly fare P95](./fact_taxi_trips_monthly_fare_p95.sql)
* [FHV trips dimension](./dim_fhv_trips.sql)
* [FHV monthly zone traveltime P90](./fact_fhv_monthly_zone_traveltime_p90.sql)

## Question 5
A screenshot of the fact_taxi_trips_quarterly_revenue table from BigQuery is shown [here](./images/hw4_q5_1.png)<br/>

Answer: **green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}**

## Question 6
A screenshot of the fact_taxi_trips_quarterly_revenue table from BigQuery is shown [here](./images/hw4_q6_1.png)<br/>

Answer: **green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}**

## Question 7
A screenshot of the fact_taxi_trips_quarterly_revenue table from BigQuery is shown [here](./images/hw4_q7_1.png)<br/>

Answer: **LaGuardia Airport, Chinatown, Garment District**

