{{ config(materialized='table') }}

with fhv_trip_duration as (
    select
      *,
      timestamp_diff(dropoff_datetime, pickup_datetime, SECOND) as trip_duration
    from 
      {{ ref('dim_fhv_trips') }}
),
p90_trip as (
    select
      DISTINCT
      month_name,
      year_number,
      pickup_locationid,
      pickup_zone,
      dropoff_locationid,
      dropoff_zone,
      percentile_cont(trip_duration, 0.90) OVER (PARTITION BY year_number, month_name, pickup_locationid, dropoff_locationid) as p90
    from
        fhv_trip_duration
    where
        pickup_zone in ('Newark Airport', 'SoHo','Yorkville East')
        and month_name = 'November' and year_number = 2019
)

select
  pickup_zone,
  dropoff_zone,
  p90,
  NTH_VALUE(dropoff_zone, 2) 
    OVER(
          PARTITION BY pickup_locationid 
          ORDER BY p90 DESC 
          ROWS BETWEEN 
            UNBOUNDED PRECEDING AND 
            CURRENT ROW
    ) as second_longest_p90_trip_duration_dropoff_zone
from
  p90_trip