# FlexyBoots - A Flexible Bootstrapped Data Infrastructure

The goal of this repo is to provide a rapidly deployable cloud infastructure which can be adapted to serve varying data needs. By default, the infrastructure provides:
-  ETL / ELT Pipeline Scripts
-  ETL / ELT Pipeline Orchestration (Airflow / Composer)
-  VM-hosted Data Integration Platform (Airbyte)
-  VM-hosted Data Visualisation / BI Platform (Metabase)
-  Data-warehousing functionality (BigQuery)
-  Data Lineage & Quality Monitoring (Amundsen / Great Expectations)

 This is all implemented using Terraform infrastructure as code (IaC), allowing for zero to one improvements to your data architecture within 30 minutes. The infrastructure is based on Google Cloud Platform (GCP). However, porting the majority of the infrastructure to alternative cloud providers (E.g. AWS or Azure) should be possible with some changes to the provided code. 

# Deployment 
