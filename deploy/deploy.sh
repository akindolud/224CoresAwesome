#!/bin/sh

# A shell script to create and delete a deployment on GCP.
# To use this file, set the required variables and run using bash in GCP cloud shell

# Create variable name for GCP deployment
# Enter the project id between the quotes to replace my-project-id before running this bash script
PROJECT_ID="my-project-id"
DEPLOYMENT_NAME="test-deployment"
DEPLOYMENT_ZONE="us-central1-a"
INSTANCE_NAME=$DEPLOYMENT_NAME-vm
SLEEP_SECONDS=300

# Print a display message to show the shell script is now running
echo "0. Script running, your deployment will be created in several stages and might take a few minutes"

# Set your project to that defined in the DEVSHELL_PROJECT_ID environment variable
echo "1. Now setting the project to " $DEVSHELL_PROJECT_ID
gcloud config set project $PROJECT_ID

# Enable the following gcloud services
# 1. compute engine api
# 2. deployment manager
echo "2. Now enabling the compute and deployment manager services"
gcloud services enable compute.googleapis.com
gcloud services enable deploymentmanager.googleapis.com

# Use 'sed' to set the [PROJECT_ID] [DEPLOYMENT_NAME] and [DEPLOYMENT_ZONE] in the .yaml config file
echo "3. Now setting the project ID and deployment name in the your config file"
sed -i "s/PROJECT_ID/$DEVSHELL_PROJECT_ID/g" vmconfig.yaml
sed -i "s/DEPLOYMENT_NAME/$DEPLOYMENT_NAME/g" vmconfig.yaml
sed -i "s/DEPLOYMENT_ZONE/$DEPLOYMENT_ZONE/g" vmconfig.yaml

# Your resources will be deployed on GCP in this step using the specs in the config file
echo "4. Now deploying your resources on GCP, please wait for it to complete..."
gcloud deployment-manager deployments create $DEPLOYMENT_NAME --config vmconfig.yaml
echo "Deployment complete, showing details"
gcloud deployment-manager deployments describe $DEPLOYMENT_NAME
sleep $SLEEP_SECONDS

# Configure ssh
# rm ~/.ssh/google_compute_engine
gcloud compute config-ssh --force-key-file-overwrite
sleep $SLEEP_SECONDS

# Use ssh command to setup vm, the setup script is "startup.sh"
echo "Now sending commands to " $INSTANCE_NAME.$DEPLOYMENT_ZONE.$PROJECT_ID
# ssh -o StrictHostKeyChecking=no $INSTANCE_NAME"."$DEPLOYMENT_ZONE"."$PROJECT_ID "bash -s" < startup.sh
gcloud compute ssh $INSTANCE_NAME --zone $DEPLOYMENT_ZONE --command 'bash -s' < startup.sh

# Use ssh command to source ~/.bashrc and run a simulation, the setup script is "runCase.sh"
echo "Now sending commands to " $INSTANCE_NAME.$DEPLOYMENT_ZONE.$PROJECT_ID
# ssh -o StrictHostKeyChecking=no $INSTANCE_NAME"."$DEPLOYMENT_ZONE"."$PROJECT_ID "bash -s" < startup.sh
gcloud compute ssh $INSTANCE_NAME --zone $DEPLOYMENT_ZONE --command 'bash -i' < runCase.sh 

# Wait or carryout some actions before deleting deployment
echo "Sleeping for 1 minute before deleting resources"
sleep $SLEEP_SECONDS

# Your resources will be deleted in this section.
echo "Now deleting resources on GCP"
echo y | gcloud deployment-manager deployments delete $DEPLOYMENT_NAME
