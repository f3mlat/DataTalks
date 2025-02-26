{{ config(materialized='table') }}

select *
from {{ ref('fact_taxi_trips') }}
where DATE(pickup_datetime) >= DATE_ADD(DATE("2020-01-01"), INTERVAL {{ var("days_back", env_var("DAYS_BACK", "-30")) }}  DAY)

-- dbt build --select <model_name> --vars '{'days_back': '-7'}'