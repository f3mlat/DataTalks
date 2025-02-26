{{ config(materialized='table') }}

with trips_data as (
  select * from {{ ref('fact_trips') }}
),
filtered_trips_data as (
  select
    d.year_number,
    d.month_name,
    t.service_type,
    t.fare_amount
  from
    trips_data as t
    inner join {{ref("dim_date")}} as d  
    on {{ dbt.safe_cast("t.pickup_datetime", api.Column.translate_type("date")) }} = d.date_day
  where
    t.fare_amount > 0 and t.trip_distance > 0 and t.payment_type_description in ('Cash', 'Credit card')
)

select
  DISTINCT
  service_type,
  month_name,
  year_number,
  percentile_cont(fare_amount, 0.97) OVER (PARTITION BY service_type, year_number, month_name) as p97,
  percentile_cont(fare_amount, 0.95) OVER (PARTITION BY service_type, year_number, month_name) as p95,
  percentile_cont(fare_amount, 0.90) OVER (PARTITION BY service_type, year_number, month_name) as p90  
from
  filtered_trips_data
where 
  month_name = 'April' and year_number = 2020
order by 1