#!/bin/sh

# A shell script to create and delete a deployment on GCP.
# To use this file, set the required variables and run using bash in GCP cloud shell

# Create variable name for GCP deployment
DEPLOYMENT_NAME="test-deployment"
DEPLOYMENT_ZONE="us-central1-a"
SLEEP_SECONDS=600

# Print a display message to show the shell script is now running
echo "0. Script running, your deployment will be created in several stages and might take a few minutes"

# Set your project to that defined in the DEVSHELL_PROJECT_ID environment variable
echo "1. Now setting the project to " $DEVSHELL_PROJECT_ID
gcloud config set project $DEVSHELL_PROJECT_ID

# Enable the following gcloud services
# 1. compute engine api
# 2. deployment manager
echo "2. Now enabling the compute and deployment manager services"
gcloud services enable compute.googleapis.com
gcloud services enable deploymentmanager.googleapis.com

# Use 'sed' to set the [PROJECT_ID] [DEPLOYMENT_NAME] and [DEPLOYMENT_ZONE] in the .yaml config file
echo "3. Now setting the project ID and deployment name in the your config file"
sed -i "s/[PROJECT_ID]/$DEVSHELL_PROJECT_ID/g" vmconfig.yaml
sed -i "s/[DEPLOYMENT_NAME]/$DEPLOYMENT_NAME/g" vmconfig.yaml
sed -i "s/[DEPLOYMENT_ZONE]/$DEPLOYMENT_ZONE/g" vmconfig.yaml

# Your resources will be deployed on GCP in this step using the specs in the config file
echo "4. Now deploying your resources on GCP, please wait for it to complete..."
gcloud deployment-manager deployments create $DEPLOYMENT_NAME --config vmconfig.yaml
echo "Deployment complete, showing details"
gcloud deployment-manager deployments describe $DEPLOYMENT_NAME

# Wait or carryout some actions before deleting deployment
echo "Sleeping for 10 minutes before deleting resources"
sleep $SLEEP_SECONDS

# Your resources will be deleted in this section.
echo "Now deleting resources on GCP"
gcloud deployment-manager deployments delete $DEPLOYMENT_NAME
