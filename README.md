# Hospital Readmissions Project

This project involves analyzing the Hospital Readmissions Reduction Program (HRRP) dataset from the Centers for Medicare & Medicaid Services (CMS). The primary goal is to forecast patient intake flow and predict trends in hospital data.

## Project Overview

The project includes:
1. A Cloud Function (ELT Pipeline) to ingest hospital readmissions data from a Google Cloud Storage bucket into BigQuery.
2. Jupyter notebooks for data exploration and analysis.
3. Data and visualization resources.

## Data Source

The dataset used in this project is the [Hospital Readmissions Reduction Program (HRRP)](https://data.cms.gov/provider-data/dataset/9n3s-kdb3#data-dictionary) from CMS. This dataset contains information about hospital readmissions, including various measures related to the quality of care.

### Data Dictionary

- **Facility Name**: The name of the hospital facility.
- **Facility ID**: Unique identifier for the hospital facility.
- **State**: The state in which the hospital is located.
- **Measure Name**: The name of the measure used to assess readmissions.
- **Number of Discharges**: The number of discharges for the specific measure.
- **Footnote**: Additional information or notes.
- **Excess Readmission Ratio**: Ratio indicating the excess readmissions for the hospital.
- **Predicted Readmission Rate**: Predicted rate of readmissions based on the measure.
- **Expected Readmission Rate**: Expected rate of readmissions based on the measure.
- **Number of Readmissions**: Actual number of readmissions.
- **Start Date**: The start date of the reporting period.
- **End Date**: The end date of the reporting period.

## Project Structure
hospital_readmission_project/
├── data/
│ └── Hospital_Readmissions_Reduction_Program_Hospital.csv
├── function/
│ ├── main.py
│ ├── schema.json
│ ├── requirements.txt
│ └── other_files.py
├── notebooks/
│ ├── data_exploration.ipynb
│ └── modelling_and_analysis.ipynb
├── visualizations/
│ └── files
├── ingest/
│ ├── src/
│ │ └── transformation.sql
│ ├── main.py
│ ├── requirements.txt
├── terraform_gcf/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── terraform.tfvars
│ └── function.zip
└── deploy.sh


### Event-Driven ETL Pipeline

An event-driven ETL pipeline responds to events (e.g., new data file uploads) to trigger data processing. In this case, we will use Google Cloud Functions and BigQuery for our ETL pipeline.

Steps in the Pipeline:

 1. Data Ingestion (Bronze Layer)
        Trigger: A new data file is uploaded to a Google Cloud Storage bucket.
        Action: A Cloud Function is triggered by the file upload event.
        Processing: The Cloud Function reads the raw data from the file and loads it into a BigQuery table in the Bronze layer.
                    The function schema is defined in `schema.json` and dynamically loaded.
 2. Data Transformation (Silver Layer)
        Processing: The function/query reads data from the Bronze table, processes and cleans it (e.g., removing duplicates, handling missing values), and loads the refined data into a Silver table.
 3. Data Aggregation (Gold Layer)
        Processing: The SQL queries aggregates and enriches the data (e.g., calculating metrics, summarizing data).

### Notebooks

- **data_exploration.ipynb**: Contains initial data exploration and cleaning steps.
- **modelling_and_analysis.ipynb**: Includes modeling and analysis steps for predicting readmission rates and other insights.

### Data

The `data` folder contains the raw data files used in the project.


## Requirements

- Google Cloud SDK (`gcloud`)
- Terraform
- Python 3.9

### Installing Google Cloud SDK (`gcloud`)

1. **Download the SDK**: Visit the [Google Cloud SDK installation page](https://cloud.google.com/sdk/docs/install) and download the appropriate version for your operating system.
2. **Install the SDK**: Follow the instructions for your OS:
   - **Windows**: Run the downloaded installer.
   - **MacOS**: Use the package manager or the installer.
   - **Linux**: Use the package manager or the tarball.
3. **Initialize the SDK**: Open a terminal and run:
   ```bash
   gcloud init

Installing Terraform

 1. Download Terraform: Visit the Terraform installation page and download the appropriate version for your operating system.
 2. Install Terraform: Follow the instructions for your OS:
        1. Windows: Unzip the downloaded file and move the terraform.exe to a directory included in your system's PATH.
        2. MacOS and Linux: Unzip the downloaded file and move the terraform binary to /usr/local/bin.

Deploying the Project
You can deploy the project using either the deploy.sh script or directly with Terraform.

Using deploy.sh

Authenticate with Google Cloud:

 1. gcloud auth login
 2. gcloud config set project your-project-id

Run the deployment script:
 1. ./deploy.sh

Using Terraform Directly

Navigate to the Terraform directory:

 1. cd terraform_gcf
 2. Initialize Terraform:
    terraform init
 3. Plan the deployment:
    terraform plan -out=tfplan
 4. Apply the deployment:
    terraform apply tfplan

Usage
Upload your CSV files to the specified Google Cloud Storage bucket to trigger the Cloud Function and ingest data into BigQuery.






