### Setting Up Secrets

To securely access AWS services and other sensitive information, set up the following secrets in your GitHub repository:

-   `AWS_ACCESS_KEY_ID`: AWS access key ID with permissions to interact with AWS services.
-   `AWS_SECRET_ACCESS_KEY`: AWS secret access key corresponding to the access key ID.
-   `KUBECONFIG`: Base64-encoded Kubernetes configuration file (`kubeconfig.yaml`).

# Workflow Overview

## **`build.yaml`** Pipeline

### Pipeline Triggers

The Deploy Pipeline is triggered in the following scenarios:

-   Pushes to the  `master`  branch.
-   Pull requests targeting the  `master`  branch.

### Environment Variables

The pipeline uses the following environment variables:

-   `AWS_REGION`: The AWS region where your services are hosted (e.g.,  `eu-west-1`).
-   `FE-ECR_REPOSITORY`: Elastic Container Registry (ECR) repository name for the frontend application.
-   `BE-ECR_REPOSITORY`: ECR repository name for the backend application.
-   `SHORT_SHA`: The first 8 characters of the GitHub commit SHA.

### Job Descriptions

The pipeline consists of three jobs:

**`run-tests`  Job:**

-   Responsible for testing the web application.
-   Runs  `npm install`  and  `npm test`  in the  `code/site`  directory.

**`build-fe`  Job:**

-   Builds and pushes the frontend Docker image to ECR.
-   Executes when changes are pushed to the  `master`  branch.
-   Depends on the successful completion of the  `run-tests`  job.

**`build-be`  Job:**

-   Builds and pushes the backend Docker image to ECR.
-   Executes when changes are pushed to the  `master`  branch.
-   Depends on the successful completion of the  `run-tests`  job.

**`Deploy`  Job:**
Purpose: This stage deploys the application to different environments (Development and Production).
Execution: It uses a custom deployment script (deploy.yaml) to perform the deployment based on the target environment specified. This stage runs after successful completion of both frontend and backend build stages and allows deployments to different target environments.

# **`deploy.yaml`** Pipeline


### Running the Pipeline

1.  Ensure that the required secrets (`AWS_ACCESS_KEY_ID`,  `AWS_SECRET_ACCESS_KEY`, and  `KUBECONFIG`) are set up in your GitHub repository.
2.  Push changes to the  `master`  branch or create a pull request targeting  `master`.
3.  The pipeline will automatically trigger and execute the specified jobs based on the changes made.

## Reusable Deployment Workflow

This GitHub Actions workflow enables reusable deployment to different target environments (Development and Production). It automates the deployment process for your application based on the specified target environment.

## Workflow Trigger

The workflow is triggered using a `workflow_call` event with the following inputs:

- `target-env`: Specifies the target environment for deployment (required). You can choose either 'Development' or 'Production'.

### Secrets

The workflow requires the following secrets to be defined in your GitHub repository:

- `AWS_ACCESS_KEY_ID`: AWS Access Key ID with necessary permissions.
- `AWS_SECRET_ACCESS_KEY`: AWS Secret Access Key.
- `KUBECONFIG`: Kubernetes configuration in base64-encoded format.

## Environment

- The workflow runs on an Ubuntu latest runner.
- Deployment is restricted to the `master` branch to ensure controlled deployments.

## Steps

### 1. Initialize

- This step echoes the target environment for reference in the workflow.

### 2. Clone Repository

- It checks out the repository code for deployment.

### 3. Configure AWS Credentials

- This step configures AWS credentials using the provided secrets.
- AWS Access Key ID, Secret Access Key, and the AWS region (`eu-west-1`) are used to authenticate with AWS services.

### 4. Install and Configure kubectl

- Installs `kubectl` to interact with Kubernetes clusters.
- Decodes the base64-encoded Kubernetes configuration (`KUBECONFIG`) and sets up the `kubectl` configuration for cluster access.

### 5. Login to Amazon ECR

- Uses the AWS Access Key ID and Secret Access Key to log in to Amazon Elastic Container Registry (ECR) to access Docker images.

### 6. Deploy to Development

- Executes the deployment to the Development environment if the `target-env` input is 'Development'.
- Sets environment variables for the ECR registry, Docker image tags, and repositories.
- Applies Kubernetes manifests using `kubectl` to deploy the application to the Development environment.

### 7. Deploy to Production

- Executes the deployment to the Production environment if the `target-env` input is 'Production'.
- Similar to the Development deployment, it sets environment variables for the ECR registry, Docker image tags, and repositories.
- Applies Kubernetes manifests using `kubectl` to deploy the application to the Production environment.

This workflow allows you to trigger deployments to different environments by specifying the `target-env` input when calling the workflow. It helps automate and streamline the deployment process while ensuring that AWS and Kubernetes configurations are properly handled.
