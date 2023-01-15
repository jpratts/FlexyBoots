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

The ETL process follows a 5 stage process. Fundamentally, each stage is a Python script along with a set of BigQuery queries. Scripts and script generation relies on a variety of functions and generators. All of the stages are orchestrated on Airflow:  Staging -> Archive -> Delta -> Transform -> DWH / Consumption

1. **Staging**  
*Rationale*:  Staging Layer is responsible for the movement of data from the source platform onto the DWH platform.  
*Features*: 1:1 Copy of source data, no transformation, no aggreggation, may be temporary.  
*Process*: Bucket -> No Logic -> StagingTable
2. **Archive**  
*Rationale*: Full data history and backup, ensures uniqueness of incoming data.  
*Features*: Only field name transformations are permitted (e.g. 'id' -> 'OpenBankingId'), no aggreggation, partitioning, CDC, must be permanent.  
*Process*: StagingTable -> Field Renaming & Uniqueness Checks -> ArchiveTable
3. **Delta**  
*Rationale*: Calculates rows to be upserted into DWH / Consumption layer.  
*Features*: 1:1 Copy of ArchiveTable rows which are not in, or are different, in DWH. May be temporary.  
*Process*: ArchiveTable -> Calculate Upserts -> DeltaTable
4. **Transform**  
*Rationale*: Perform transformation need to adhere to planned schema for DWH model.  
*Features*: Automated transformation of rows in DeltaTable, may be temporary.   
*Process*: DeltaTable -> Perform Transformation -> TransformedTable  
5. **DWH / Consumption**  
*Rationale*: Upserts rows into DWH / Consumption layer.  
*Features*: 1:1 upsert of TransformedTable into DWH, DWH may be partitioned.  
*Process*: TransformedTable -> No Logic -> DWH / Consumption



