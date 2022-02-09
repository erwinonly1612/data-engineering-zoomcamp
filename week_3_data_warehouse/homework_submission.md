## Homework
[Form](https://forms.gle/ytzVYUh2RptgkvF79)  
We will use all the knowledge learned in this week. Please answer your questions via form above.  
**Deadline** for the homework is 14th Feb 2022 17:00 CET.

### DAG Code is at: **https://github.com/erwinonly1612/data-engineering-zoomcamp/blob/main/week_3_data_warehouse/airflow_learn/dags/gcs_to_bq_dag.py**

### Question 1: 
**What is count for fhv vehicles data for year 2019**  
Can load the data for cloud storage and run a count(*)
### Answer: 42084899
### SQL:
~~~~sql
SELECT COUNT(1) FROM `dtc-de-338802.trips_data_all.fhv_tripdata` 
~~~~

### Question 2: 
**How many distinct dispatching_base_num we have in fhv for 2019**  
Can run a distinct query on the table from question 1
### Answer: 792
### SQL:
~~~~sql
SELECT COUNT(DISTINCT dispatching_base_num) FROM `dtc-de-338802.trips_data_all.fhv_tripdata` 
~~~~

### Question 3: 
**Best strategy to optimise if query always filter by dropoff_datetime and order by dispatching_base_num**  
Review partitioning and clustering video.   
We need to think what will be the most optimal strategy to improve query 
performance and reduce cost.
### Answer: Partition by dropoff_datetime and cluster by dispatching_base_num

### Question 4: 
**What is the count, estimated and actual data processed for query which counts trip between 2019/01/01 and 2019/03/31 for dispatching_base_num B00987, B02060, B02279**  
Create a table with optimized clustering and partitioning, and run a 
count(*). Estimated data processed can be found in top right corner and
actual data processed can be found after the query is executed.
### Answer: Count: 26558, Estimated data processed: 400 MB, Actual data processed: 155 MB
### SQL:
~~~~sql
CREATE OR REPLACE TABLE dtc-de-338802.trips_data_all.fhv_tripdata_partitioned_clustered
PARTITION BY DATE(pickup_datetime)
CLUSTER BY dispatching_base_num AS
SELECT * FROM dtc-de-338802.trips_data_all.fhv_tripdata_external_table;

SELECT COUNT(*) FROM `dtc-de-338802.trips_data_all.fhv_tripdata_partitioned_clustered` 
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-03-31'
AND dispatching_base_num IN ('B00987','B02060','B02279');
~~~~

### Question 5: 
**What will be the best partitioning or clustering strategy when filtering on dispatching_base_num and SR_Flag**  
Review partitioning and clustering video. 
Clustering cannot be created on all data types.
### Answer:  Partition by dispatching_base_num and cluster by SR_Flag because there are many null values in SR_Flag

### Question 6: 
**What improvements can be seen by partitioning and clustering for data size less than 1 GB**  
Partitioning and clustering also creates extra metadata.  
Before query execution this metadata needs to be processed.
### Answer:No improvements and also can be worse due to metadata

### (Not required) Question 7: 
**In which format does BigQuery save data**  
Review big query internals video.
### Answer: Columnar
