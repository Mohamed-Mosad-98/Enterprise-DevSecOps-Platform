# Enterprise DevSecOps Platform

A production-oriented **DevSecOps platform** for deploying and operating a containerized Java application on **Amazon EKS**, with infrastructure provisioned using Terraform and application workloads managed through Kubernetes and Helm.

The project demonstrates an end-to-end cloud-native workflow covering infrastructure provisioning, containerization, Kubernetes deployment, AWS integration, monitoring, backup, and security practices.

---

## Architecture

![Uploading Cloud DevSecOps pipeline architecture diagram.png…]()




---

## Project Overview

This project implements a complete DevSecOps environment on AWS for running the **VProfile Java application** on Amazon EKS.

The platform is organized into separate layers:

* **Application Layer** — Java application and supporting services
* **Container Layer** — Docker images and container configuration
* **Infrastructure Layer** — AWS infrastructure provisioned with Terraform
* **Kubernetes Layer** — Helm charts and Kubernetes workloads
* **Storage Layer** — Persistent storage through Amazon EBS
* **AWS Integration** — ECR, IAM, EKS, VPC and load balancing
* **Operations Layer** — Monitoring, backup and operational tooling
* **Security Layer** — IAM, IRSA, Kubernetes Secrets and DevSecOps practices

---

## Technology Stack

| Category                | Technologies                 |
| ----------------------- | ---------------------------- |
| Cloud                   | AWS                          |
| Container Orchestration | Amazon EKS                   |
| Infrastructure as Code  | Terraform                    |
| Containers              | Docker                       |
| Package Management      | Helm                         |
| Container Registry      | Amazon ECR                   |
| Storage                 | Amazon EBS / EBS CSI         |
| Load Balancing          | AWS Load Balancer Controller |
| IAM                     | AWS IAM / IRSA               |
| Backup                  | Velero / Amazon S3           |
| Monitoring              | Prometheus / Grafana         |
| Application             | Java / Spring-based VProfile |
| Build                   | Maven                        |
| Version Control         | Git / GitHub                 |
| OS / Administration     | Linux                        |

---

# Repository Structure

```text
Enterprise-DevSecOps-Platform/
│
├── aws/
│   └── iam/
│       └── velero-trust-policy.json
│
├── java-application/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── pom.xml
│   ├── README.md
│   └── src/
│       ├── main/
│       │   ├── java/
│       │   ├── resources/
│       │   └── webapp/
│       └── test/
│
├── platform-infrastructure/
│   ├── backend.tf
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── locals.tf
│   ├── iam-policies.tf
│   │
│   └── modules/
│       ├── aws-load-balancer-controller/
│       ├── ebs-csi/
│       ├── ecr/
│       ├── eks/
│       ├── iam/
│       ├── iam-irsa/
│       └── vpc/
│
├── platform-kubernetes/
│   └── helm/
│       └── vprofile/
│           ├── Chart.yaml
│           ├── values.yaml
│           ├── files/
│           └── templates/
│
└── .gitignore
```

---

# Infrastructure as Code

The AWS infrastructure is managed using **Terraform**.

The infrastructure layer is modularized to make the environment easier to maintain and extend.

### Main Terraform Components

* VPC networking
* Amazon EKS cluster
* EKS node groups
* Amazon ECR repositories
* IAM roles and policies
* IAM Roles for Service Accounts (IRSA)
* AWS Load Balancer Controller
* Amazon EBS CSI Driver
* Supporting AWS resources

The infrastructure is organized into reusable Terraform modules:

```text
platform-infrastructure/modules/

├── vpc/
├── eks/
├── ecr/
├── iam/
├── iam-irsa/
├── ebs-csi/
└── aws-load-balancer-controller/
```

This modular approach separates infrastructure responsibilities and allows individual components to be maintained independently.

---

# Amazon EKS

The application is deployed on **Amazon Elastic Kubernetes Service (EKS)**.

The Kubernetes environment provides:

* Managed Kubernetes control plane
* Worker nodes
* Kubernetes scheduling
* Service discovery
* Application scaling
* Persistent storage
* AWS load balancing integration
* IAM integration through IRSA

The EKS infrastructure is provisioned through Terraform rather than manually creating resources through the AWS Console.

---

# Containerization

The Java application is containerized using **Docker**.

The application directory contains:

```text
java-application/
├── Dockerfile
├── docker-compose.yml
├── pom.xml
└── src/
```

The Dockerfile is used to build the application image, while Docker Compose provides a local environment for running the application with its supporting services.

---

# Kubernetes Deployment

The application is packaged using **Helm**.

The Helm chart is located at:

```text
platform-kubernetes/helm/vprofile/
```

The chart contains Kubernetes templates for the application and its supporting components.

### Kubernetes Resources

The Helm chart includes configurations for:

* Application Deployment
* Application Service
* Ingress
* Horizontal Pod Autoscaler
* ServiceAccount
* ConfigMap
* Secret
* MySQL
* MySQL Service
* MySQL PVC
* RabbitMQ
* RabbitMQ Service
* Memcached
* Memcached Service

This allows the complete application stack to be deployed consistently using Helm.

---

# Helm Chart Structure

```text
vprofile/
│
├── Chart.yaml
├── values.yaml
├── .helmignore
│
├── files/
│   └── db_backup.sql
│
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    ├── configmap.yaml
    ├── secret.yaml
    ├── serviceaccount.yaml
    ├── hpa.yaml
    │
    ├── mysql/
    │   ├── deployment.yaml
    │   ├── service.yaml
    │   ├── configmap.yaml
    │   └── pvc.yaml
    │
    ├── rabbitmq/
    │   ├── deployment.yaml
    │   └── service.yaml
    │
    └── memcached/
        ├── deployment.yaml
        └── service.yaml
```

---

# AWS Load Balancer Controller

The platform integrates Kubernetes Ingress with AWS through the **AWS Load Balancer Controller**.

The controller allows Kubernetes Ingress resources to provision and manage AWS load balancing infrastructure.

The Terraform infrastructure includes:

* IAM policies
* IAM roles
* IRSA configuration
* AWS Load Balancer Controller deployment

This provides AWS-native traffic management for the Kubernetes application.

---

# Persistent Storage

Persistent application storage is integrated with Amazon EKS through the **Amazon EBS CSI Driver**.

The EBS CSI integration allows Kubernetes PersistentVolumeClaims to dynamically provision Amazon EBS volumes.

The platform includes a dedicated Terraform module:

```text
platform-infrastructure/modules/ebs-csi/
```

This separates storage infrastructure from the rest of the EKS configuration.

---

# IAM and IRSA

AWS permissions are handled using **IAM** and **IAM Roles for Service Accounts (IRSA)**.

IRSA allows Kubernetes workloads to assume AWS IAM roles without storing long-lived AWS credentials inside containers.

This approach provides:

* Least-privilege AWS permissions
* Workload-level AWS access
* Better credential security
* Separation between Kubernetes identities and AWS permissions

---

# Backup and Disaster Recovery

The platform includes **Velero** for Kubernetes backup and recovery.

Velero is integrated with **Amazon S3** as the backup storage backend.

The repository contains the IAM trust policy required for the Velero integration:

```text
aws/
└── iam/
    └── velero-trust-policy.json
```

The backup architecture provides a mechanism for protecting Kubernetes resources and application workloads.

Example backup organization:

```text
S3 Bucket
│
├── full-cluster-backup/
├── monitoring-backup/
└── vprofile-backup/
```

This allows backups to be logically separated according to the protected workloads.

---

# Monitoring

The platform is designed to support Kubernetes and application observability using:

* Prometheus
* Grafana

Prometheus can be used for collecting Kubernetes and application metrics, while Grafana provides dashboards for visualization and operational monitoring.

The monitoring layer helps operators identify:

* Resource utilization
* Application health
* Pod status
* Node status
* Performance issues
* Operational anomalies

---

# Security

Security is incorporated throughout the platform rather than treated as a separate deployment stage.

The project applies several security practices:

### Infrastructure Security

* IAM policies
* IAM roles
* IRSA
* AWS security controls
* Private infrastructure components where applicable

### Kubernetes Security

* Kubernetes Secrets
* ServiceAccounts
* RBAC-oriented access control
* Dedicated workload identities
* Controlled AWS permissions

### Repository Security

Sensitive runtime and infrastructure files are excluded from Git using `.gitignore`.

Examples include:

```text
*.tfstate
*.tfstate.*
*.tfvars
.env
*.pem
*.key
application.properties
```

Credentials and environment-specific configuration should be supplied through secure configuration mechanisms rather than committed to the repository.

---

# Application

The application is a Java-based **VProfile** application.

The application integrates with several supporting services:

```text
Java Application
       │
       ├── MySQL
       ├── RabbitMQ
       ├── Memcached
       └── Elasticsearch
```

The application source code, Maven configuration, Docker configuration, tests, and web resources are maintained under:

```text
java-application/
```

---

# Local Development

The application includes Docker Compose configuration for local development.

```bash
cd java-application
docker compose up -d
```

To stop the local environment:

```bash
docker compose down
```

For building the Java application:

```bash
mvn clean package
```

---

# Terraform Workflow

Navigate to the infrastructure directory:

```bash
cd platform-infrastructure
```

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

Destroy the infrastructure when it is no longer required:

```bash
terraform destroy
```

> **Important:** Never commit Terraform state files or sensitive `.tfvars` files to the repository.

---

# Kubernetes Deployment

After the EKS cluster is available and `kubectl` is configured:

```bash
aws eks update-kubeconfig \
  --region <AWS_REGION> \
  --name <EKS_CLUSTER_NAME>
```

Verify cluster connectivity:

```bash
kubectl get nodes
```

Deploy the VProfile Helm chart:

```bash
helm upgrade --install vprofile \
  ./platform-kubernetes/helm/vprofile
```

Verify the deployment:

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

---

# Operational Verification

Useful commands for troubleshooting the environment:

### Kubernetes

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

### Application Logs

```bash
kubectl logs <pod-name>
```

### Pod Details

```bash
kubectl describe pod <pod-name>
```

### Helm

```bash
helm list
helm status vprofile
```

### Terraform

```bash
terraform state list
terraform output
```

These commands provide basic visibility into infrastructure and application health.

---

# DevSecOps Workflow

The project follows a DevSecOps-oriented workflow:

```text
Source Code
     │
     ▼
Git Repository
     │
     ▼
Application Build
     │
     ▼
Docker Image
     │
     ▼
Container Registry
     │
     ▼
Amazon EKS
     │
     ▼
Kubernetes / Helm
     │
     ├── Monitoring
     ├── Security
     └── Backup
```

The platform combines infrastructure automation, containerization, Kubernetes orchestration, AWS integration, monitoring, and backup into a single operational workflow.

---

# Key Engineering Practices

The project focuses on the following engineering practices:

* Infrastructure as Code
* Modular Terraform design
* Containerized application deployment
* Kubernetes-based orchestration
* Helm-based application packaging
* AWS-native integrations
* IAM least-privilege principles
* IRSA for workload identity
* Persistent storage management
* Kubernetes backup and recovery
* Monitoring and observability
* Separation of application and infrastructure layers
* Git-based version control
* Secret and state-file protection

---

# Project Goals

The main goals of the project are to demonstrate the ability to:

1. Provision AWS infrastructure using Terraform.
2. Deploy and operate an Amazon EKS cluster.
3. Containerize a Java application.
4. Package Kubernetes workloads with Helm.
5. Integrate Kubernetes with AWS services.
6. Configure persistent storage using Amazon EBS.
7. Implement AWS IAM and IRSA.
8. Configure AWS Load Balancing for Kubernetes workloads.
9. Implement Kubernetes backup using Velero and Amazon S3.
10. Establish monitoring and operational visibility.
11. Apply security practices throughout the deployment lifecycle.

---

# Technologies Summary

```text
AWS
├── VPC
├── EKS
├── ECR
├── IAM
├── EC2
├── EBS
├── S3
└── Load Balancing

Infrastructure
├── Terraform
└── Ansible

Containers
├── Docker
└── Docker Compose

Kubernetes
├── Kubernetes
├── Helm
├── AWS Load Balancer Controller
└── EBS CSI Driver

Observability
├── Prometheus
└── Grafana

Backup
└── Velero + Amazon S3

Application
├── Java
├── Maven
├── MySQL
├── RabbitMQ
├── Memcached
└── Elasticsearch

Version Control
└── Git / GitHub
```

---

# Author

**Mohamed Mosad Fahmy**

DevOps / Cloud / Kubernetes Engineer

* GitHub: `Mohamed-Mosad-98`
* Location: Egypt

---


