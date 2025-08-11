# SQL_Data_Store

Building a modern data warehourse with SQL Server, including ETL process, 
data modeling and data analytics

## 📊 Overview

This repository is dedicated to building a modern data warehouse
using SQL Server, it includes:

- ETL process for reliable data ingestion
- Structured data modeling for analytical efficiency
- SQL-based analyticals and qeurying tools

Whether you are building dashboards, performing analytics or architecting scalable ETL pipelines,
this project lays the groundwork

## 💡 Features

- ETL Automation: Scripts for extracting, transforming and loading data
- Robust Data Modeling: Schema designs optimized for analytical queriying (Star Schema)
- Analytics and Reporting: Pre-built queries and view for common metrics and insights

## 📉 Architecture and Design

1. Data Sources - Raw input (CSV)
2. SQL Server
3. Data Warehouse - Modeled schemas (Bronze layer, Silver layer and Gold layer) optimized for analytics
4. Visualization and Reporting

<img width="1062" height="550" alt="data architecture" src="https://github.com/user-attachments/assets/556d9987-ac79-4ab9-9c8a-a2a21220ccb7" />

## Usage 

⏩ Run specific ETL pipeline(Stored Procedure)

``` EXECUTE bronze.load_bronze; ```

⏩ Query the analytics layer

``` SELECT *  FROM gold.dim_customers; ```


⏩ Connect BI tools to the database for dashboarding
   

