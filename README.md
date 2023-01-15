# FlexyBoots - A Flexible Bootstrapped Data Infrastructure

The goal of this repo is to provide a rapidly deployable cloud infastructure which can be adapted to serve varying data needs. By default, the infrastructure provides:
-  ETL / ELT Pipeline Scripts
-  ETL / ELT Pipeline Orchestration (Airflow / Composer)
-  VM-hosted Data Integration Platform (Airbyte)
-  VM-hosted Data Visualisation / BI Platform (Metabase)
-  Data-warehousing functionality (BigQuery)
-  Data Lineage & Quality Monitoring (Amundsen / Great Expectations)

 This is all implemented using Terraform infrastructure as code (IaC), allowing for zero to one improvements to your data architecture within 30 minutes. The infrastructure is based on Google Cloud Platform (GCP). However, porting the majority of the infrastructure to alternative cloud providers (E.g. AWS or Azure) should be possible with some changes to the provided code. 

# ETL Pipeline

The ETL process follows a 5 stage process. Fundamentally, each stage is a Python script along with a set of BigQuery queries. Scripts and script generation relies on a variety of functions and generators. All of the stages are orchestrated on Airflow:  Staging -> Archive -> Transform -> Delta -> DWH / Consumption

1. **Staging**  
*Rationale*:  Staging Layer is responsible for the movement of data from the source platform onto the DWH platform.  
*Features*: 1:1 Copy of source data, No transformation, no aggreggation.    
4. **Archive**  
*Rationale*: Full data history and backup.  
*Features*: 1:1 copy of staging, no transformation, no aggreggation, partitioning, CDC.    
7. **Transform**  
*Rationale*: Maps source data to planned schema for DW model.  
*Features*: automated transformation, partitioning.    
10. **Delta**  
*Rationale*: Stages final transformed data for upsert into DWH / Consumpation layer. 
