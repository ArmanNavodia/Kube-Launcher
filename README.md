# 🚀 Kube-Launcher

**Kube-Launcher** is a Terraform-based automation project that provisions a fully operational **EKS cluster**, deploys an application container image to it, and configures observability using **Prometheus** and **Grafana**. It integrates **GitHub Actions** to build and push Docker images to ECR and deploys Kubernetes workloads seamlessly.

---

## 🧩 Features

- ☁️ AWS EKS cluster provisioning with Terraform
- ⚙️ GitHub Actions for CI/CD
- 📦 Dockerized app build and push to Amazon ECR
- 🚀 Kubernetes deployments and services with ingress
- 📊 Prometheus & Grafana monitoring via Helm
- 🔁 Modular infrastructure and workload separation

---

## 📁 Project Structure

```bash
.
├── .github/workflows/         # CI/CD workflows for build and deployment
├── app/                       # App source code and Dockerfile
├── infra/                     # Terraform code for VPC, EKS, and IAM
├── k8s/                       # Kubernetes manifests (deployment, service, ingress)
├── monitoring/                # Helm chart configurations for Prometheus and Grafana
└── README.md                  # Readme
```
---
## 🚀 Deployment Guide
### ✅ Prerequisites

- AWS CLI configured (aws configure)

- IAM user with EKS and ECR permissions

- Terraform v1.4+

- Docker installed and running

- kubectl & helm installed

---
### 🔨 Step 1: Provision Infrastructure (EKS Cluster)
``` bash
cd infra
terraform init
terraform apply
```
This sets up:

- VPC & subnets

- IAM roles

- EKS cluster

### 🐳 Step 2: Build and Push Docker Image
Export necessary variables:
```bash
export AWS_REGION=ap-south-1
export ECR_REPO_NAME=<your-ecr-repo>
export IMAGE_TAG=latest
```
Build and push:
```bash
cd app
docker build -t $ECR_REPO_NAME:$IMAGE_TAG .
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.$AWS_REGION.amazonaws.com
docker tag $ECR_REPO_NAME:$IMAGE_TAG <aws_account_id>.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG
docker push <aws_account_id>.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG
```

This process can also be triggered automatically via GitHub Actions.

For Github Actions: Add this variables to github actions secrets
```
 AWS_REGION=ap-south-1
 ECR_REPO_NAME=<your-ecr-repo>
 IMAGE_TAG=latest
```

### ☸️ Step 3: Deploy App to EKS

#### 📌 Note: The Terraform state file for Kubernetes resources is stored in an S3 backend. Make sure to configure the S3 backend in the k8s/ directory before running terraform apply.

Example provider.tf (in k8s/):
```
terraform {
  backend "s3" {
    bucket = "your-s3-bucket-name"
    key    = "k8s/terraform.tfstate"
    region = "ap-south-1"
  }
}
```
Ensure your EKS cluster is correctly referenced and that your kubeconfig is up to date.

```bash
cd k8s
terraform init
Terraform apply
```
Creates:

- Kubernetes Deployment

- ClusterIP/LoadBalancer Service

- Ingress (ensure ALB ingress controller is active)

### 📈 Step 4: Install Monitoring Stack
```bash
cd monitoring
terraform init
terraform apply
```


### 🧪 CI/CD Automation
GitHub Actions are used to:

- Automatically build & push Docker images on push to main

- Deploy Kubernetes workloads using kubectl or kustomize

Workflows are stored in:
```.github/workflows/```

You may need to add secrets to GitHub:
```
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

ECR_REPOSITORY

AWS_REGION
```



