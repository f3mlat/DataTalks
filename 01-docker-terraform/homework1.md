## Question 1
docker run -it --entrypoint=bash python:3.12.8

At the bash prompt, I entered
```shell
pip --version
```
or:
```shell
pip -V
```

Result
* pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)

Answer: 24.3.1

## Question 2
Creatd the yaml file

Command to start the services specified in the file
```shell
docker compose up
```
Registered database server in pgadmin using the hostname - db and port 5433 and was able to connect to the postgresql database

Answer: db:5433

## Question 3
```shell
SELECT	DATE(lpep_dropoff_datetime) AS TripDate,
		SUM(CASE WHEN trip_distance <= 1.00 THEN 1 ELSE 0 END) AS "UP TO 1",
		SUM(CASE WHEN trip_distance > 1.00 AND trip_distance <= 3.00 THEN 1 ELSE 0 END) AS "BTW 1 AND 3",
		SUM(CASE WHEN trip_distance > 3.00 AND trip_distance <= 7.00 THEN 1 ELSE 0 END) AS "BTW 3 AND 7",
		SUM(CASE WHEN trip_distance > 7.00 AND trip_distance <= 10.00 THEN 1 ELSE 0 END) AS "BTW AND 10",
		SUM(CASE WHEN trip_distance > 10.00 THEN 1 ELSE 0 END) AS "OVER 10"
FROM public.green_taxi_data
WHERE DATE(lpep_dropoff_datetime) >= '2019-10-01' 
		AND DATE(lpep_dropoff_datetime) < '2019-11-01'
GROUP BY ROLLUP (DATE(lpep_dropoff_datetime))
```

## Question 4
```shell
SELECT DATE(lpep_pickup_datetime)
FROM public.green_taxi_data
WHERE trip_distance = (SELECT MAX(trip_distance) FROM public.green_taxi_data)
```

## Question 5
```shell
SELECT tz."Zone", SUM(td.total_amount)
FROM public.green_taxi_data td
INNER JOIN public.taxi_zones tz ON td."PULocationID" = tz."LocationID"
WHERE DATE(td.lpep_pickup_datetime) = '2019-10-18'
GROUP BY tz."Zone"
HAVING SUM(td.total_amount) > 13000
```

## Question 6
```shell
WITH cte_east_halem_north_zone AS
(
	SELECT td.tip_amount, td."DOLocationID"
	FROM public.green_taxi_data td
	INNER JOIN public.taxi_zones tz ON td."PULocationID" = tz."LocationID"
	WHERE to_char(DATE(td.lpep_pickup_datetime), 'YYYY-MM') = '2019-10'
			AND tz."Zone" = 'East Harlem North'
)

SELECT tz."Zone"
FROM cte_east_halem_north_zone ez
INNER JOIN public.taxi_zones tz ON ez."DOLocationID" = tz."LocationID"
WHERE ez.tip_amount = (SELECT MAX(tip_amount) FROM cte_east_halem_north_zone)
```

## Question 7
Answer: terraform init, terraform apply -auto-approve, terraform destroy

The setup files with necessary changes can be found [here](./1_terraform_gcp/terraform)
