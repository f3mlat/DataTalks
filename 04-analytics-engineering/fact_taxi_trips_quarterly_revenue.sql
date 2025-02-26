{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),
quarterly_revenue_data as (
    select
	    d.year_number,
	    d.quarter_of_year,        
	    t.service_type,
	    sum(t.total_amount) as quarterly_revenue
    from
        trips_data as t
        inner join {{ref("dim_date")}} as d 
        on {{ dbt.safe_cast("t.pickup_datetime", api.Column.translate_type("date")) }} = d.date_day
    group by 2,1,3
)

select
    year_number,
    quarter_of_year,
    service_type,
    quarterly_revenue,
    RANK() OVER (PARTITION BY service_type, year_number ORDER BY quarterly_revenue DESC) as quarterly_revenue_rank,
    LAG(quarterly_revenue, 1) OVER (PARTITION BY quarter_of_year, service_type ORDER BY year_number) as prev_quarterly_revenue,
    ((quarterly_revenue - (LAG(quarterly_revenue, 1) OVER (PARTITION BY quarter_of_year, service_type ORDER BY year_number, quarterly_revenue)))/quarterly_revenue)*100 as percent_revenue_growth
from 
    quarterly_revenue_data