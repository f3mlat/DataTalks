{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *
    from {{ ref('stg_fhv_tripdata') }}
),
dim_zones as (
    select * from {{ ref('dim_zone_lookup') }}
    where borough != 'Unknown'
)

select
  f.tripid,
  f.dispatching_base_num,
  f.pickup_locationid, 
  puz.borough as pickup_borough, 
  puz.zone as pickup_zone, 
  f.dropoff_locationid,
  doz.borough as dropoff_borough, 
  doz.zone as dropoff_zone,  
  f.pickup_datetime, 
  f.dropoff_datetime,
  f.sr_flag,
  f.affiliated_base_number,
  d.year_number,
  d.month_name
from
  fhv_tripdata f
  inner join dim_zones puz
  on f.pickup_locationid = puz.locationid
  inner join dim_zones doz
  on f.dropoff_locationid = doz.locationid
 inner join {{ref("dim_date")}} as d 
  on {{ dbt.safe_cast("f.pickup_datetime", api.Column.translate_type("date")) }} = d.date_day

