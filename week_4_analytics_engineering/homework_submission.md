## Week 4 Homework - WIP
[Form]()  - To be published soon
We will use all the knowledge learned in this week. Please answer your questions via form above.  
* You can submit your homework multiple times. In this case, only the last submission will be used. 
**Deadline** for the homework is 21th Feb 2022 17:00 CET.


In this homework, we'll use the models developed during the week 4 videos and enhance the already presented dbt project using the already loaded Taxi data for fhv vehicles for year 2019 in our DWH.

We will use the data loaded for:
* Building a source table
* Building a fact table
* Create a dashboard 

### dashboard link: https://datastudio.google.com/s/pezArOj2w9Y
### dbt codes: https://github.com/erwinonly1612/ny_taxi_rides_zoomcamp

If you don't have access to GCP, you can do this locally using the ingested data from your Postgres database
instead. If you have access to GCP, you don't need to do it for local Postgres -
only if you want to.

### Question 1: 
**What is the count of records in the model fact_trips after running all models with the test run variable disabled and filtering for 2019 and 2020 data only (pickup datetime)**  
You'll need to have completed the "Build the first dbt models" video and have been able to run the models via the CLI. 
You should find the views and models for querying in your DWH.
### Answer: 61635151
### SQL:
~~~~sql
SELECT COUNT(1) FROM `dtc-de-338802.dbt_erwinonly1612.fact_trips` WHERE
DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2020-12-31'
~~~~

### Question 2: 
**What is the distribution between service type filtering by years 2019 and 2020 data as done in the videos**
You will need to complete "Visualising the data" videos, either using data studio or metabase. 
### Answer: 89.9/10.1

### Question 3: 
**What is the count of records in the model stg_fhv_tripdata after running all models with the test run variable disabled (:false)**  
Create a staging model for the fhv data for 2019 keeping only records with entries for affiliated_base_number. 
Run it via the CLI without limits (is_test_run: false).
### Answer: 42084899
### SQL:
~~~~sql
SELECT COUNT(1) FROM `dtc-de-338802.dbt_erwinonly1612.stg_fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31'
~~~~

### Question 4: 
**What is the count of records in the model fact_fhv_trips after running all dependencies with the test run variable disabled (:false)**  
Create a core model for the stg_fhv_tripdata joining with dim_zones.
Similar to what we've done in fact_trips, keep only records with knwon pickup and doproff locations entries for pickup and dropoff locations. 
Run it via the CLI without limits (is_test_run: false).
### Answer: 22676253
### SQL:
~~~~sql
SELECT COUNT(1) FROM `dtc-de-338802.dbt_erwinonly1612.fact_fhv_trips`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31'
~~~~

### Question 5: 
**What is the month with the biggest amount of rides after building a tile for the fact_fhv_trips table**
Create a dashboard with some tiles that you find interesting to explore the data. One tile should show the amount of trips per month, as done in the videos for fact_trips, based on the fact_fhv_trips table.
### Answer: January



