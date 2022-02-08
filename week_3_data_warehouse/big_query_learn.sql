-- Query public available table
SELECT station_id, name FROM
    bigquery-public-data.new_york_citibike.citibike_stations
LIMIT 100;


-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-338802.yellow_taxi_trip.external_yellow_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dtc_data_lake_dtc-de-338802/raw/yellow_tripdata_2019-*.parquet', 'gs://dtc_data_lake_dtc-de-338802/raw/yellow_tripdata_2020-*.parquet']
);

-- Check yello trip data
SELECT * FROM dtc-de-338802.yellow_taxi_trip.external_yellow_tripdata limit 10;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE dtc-de-338802.yellow_taxi_trip.yellow_tripdata_non_partitioned AS
SELECT * FROM dtc-de-338802.yellow_taxi_trip.external_yellow_tripdata;


-- Create a partitioned table from external table
CREATE OR REPLACE TABLE dtc-de-338802.yellow_taxi_trip.yellow_tripdata_partitioned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM dtc-de-338802.yellow_taxi_trip.external_yellow_tripdata;


-- Impact of partition
-- Scanning 1.6GB of data
SELECT DISTINCT(VendorID)
FROM dtc-de-338802.yellow_taxi_trip.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Scanning ~106 MB of DATA
SELECT DISTINCT(VendorID)
FROM dtc-de-338802.yellow_taxi_trip.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM `yellow_taxi_trip.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE dtc-de-338802.yellow_taxi_trip.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM dtc-de-338802.yellow_taxi_trip.external_yellow_tripdata;

-- Query scans 1.1 GB
SELECT count(*) as trips
FROM dtc-de-338802.yellow_taxi_trip.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Query scans 864.5 MB
SELECT count(*) as trips
FROM dtc-de-338802.yellow_taxi_trip.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

