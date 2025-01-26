import os
import pandas as pd
import sqlalchemy as db

engine = db.create_engine(f'postgresql://root:root@localhost:5432/ny_taxi')

df_zones = pd.read_csv("taxi_zone_lookup.csv")
df_zones.head(n=0).to_sql(name='taxi_zones', con=engine, if_exists='replace')
df_zones.to_sql(name='taxi_zones', con=engine, if_exists='replace')