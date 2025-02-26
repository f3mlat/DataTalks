{{
    config(
        materialized='table'
    )
}}

with dim_taxi_trips as (
    select * from {{ ref('dim_taxi_trips') }}
),
dim_zones as (
    select * from {{ ref('dim_zone_lookup') }}
    where borough != 'Unknown'
)

select 
    dtt.tripid, 
    dtt.vendorid, 
    dtt.service_type,
    dtt.ratecodeid, 
    dtt.pickup_locationid, 
    puz.borough as pickup_borough, 
    puz.zone as pickup_zone, 
    dtt.dropoff_locationid,
    doz.borough as dropoff_borough, 
    doz.zone as dropoff_zone,  
    dtt.pickup_datetime, 
    dtt.dropoff_datetime, 
    dtt.store_and_fwd_flag, 
    dtt.passenger_count, 
    dtt.trip_distance, 
    dtt.trip_type, 
    dtt.fare_amount, 
    dtt.extra, 
    dtt.mta_tax, 
    dtt.tip_amount, 
    dtt.tolls_amount, 
    dtt.ehail_fee, 
    dtt.improvement_surcharge, 
    dtt.total_amount, 
    dtt.payment_type, 
    dtt.payment_type_description
from dim_taxi_trips as dtt
inner join dim_zones as puz
on dtt.pickup_locationid = puz.locationid
inner join dim_zones as doz
on dtt.dropoff_locationid = doz.locationid