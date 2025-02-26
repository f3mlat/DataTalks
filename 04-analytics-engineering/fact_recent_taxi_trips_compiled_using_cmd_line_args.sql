

select *
from `dezoomcamp2025-449018`.`dezoomcampdbt`.`fact_taxi_trips`
where DATE(pickup_datetime) >= DATE_ADD(DATE("2020-01-01"), INTERVAL -7  DAY)

-- dbt build --select <model_name> --vars '{'days_back': '-7'}'