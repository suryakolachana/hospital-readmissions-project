#!/bin/bash

# Variables
PROJECT_ID="named-vine-254515" # Replace your own project ID.
FUNCTION_NAME="file-ingest"
REGION="us-east4" 
RUNTIME="python39"
BUCKET_NAME="data-sci-prod-raw-zone"
ENTRY_POINT="ingest"
TIMEOUT="540s"
MEMORY="512MB"
SOURCE_DIR="$HOME/deployment/ingest"
DEPLOYMENT_DIR="$HOME/deployment/ingest"

# # Authenticate with Google Cloud
# gcloud auth application-default login
# gcloud config set project $PROJECT_ID

echo "Setting up code structure in ~/deployment..."
rm -rf $DEPLOYMENT_DIR
mkdir -p $DEPLOYMENT_DIR

# Copy the contents of the current directory to the deployment directory
cp -R ingest/* $DEPLOYMENT_DIR

# Check if main.py exists in the deployment directory
if [ ! -f "$DEPLOYMENT_DIR/main.py" ]; then
    echo "Error: main.py not found in $DEPLOYMENT_DIR"
    exit 1
fi

echo "Deploying Cloud Function..."
gcloud functions deploy $FUNCTION_NAME \
    --entry-point $ENTRY_POINT \
    --runtime $RUNTIME \
    --trigger-bucket $BUCKET_NAME \
    --timeout $TIMEOUT \
    --memory $MEMORY \
    --source $DEPLOYMENT_DIR

echo "Deployment script executed successfully."