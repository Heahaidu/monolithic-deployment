# 🚀 Automation Deployment – Monolithic Application

## 🛠️ Tech Stack & Skills Demonstrated

<div align="center">

![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&ogoColor=white) ![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) ![Amazon EC2](https://img.shields.io/badge/Amazon_EC2-FF9900?style=flat&logo=amazonaws&logoColor=white) ![Amazon ECR](https://img.shields.io/badge/Amazon_ECR-FF9900?style=flat&logo=amazonaws&logoColor=white) ![Amazon RDS](https://img.shields.io/badge/Amazon_RDS-527FFF?style=flat&logo=amazonrds&logoColor=white) ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white) ![AWS SSM](https://img.shields.io/badge/AWS_SSM-FF9900?style=flat&logo=amazonaws&logoColor=white)

</div>

---

## 🔧 Infrastructure & Delivery Approaches

| Item | Detail |
|---|---|
| **IaC** | Terraform |
| **CI/CD** | Jenkins |
| **Container Registry** | Amazon ECR |
| **Remote Execution** | AWS SSM (no SSH required) |
| **Cloud Provider** | AWS |

---

## 1) System Architecture

![System Architecture](./docs/images/architecture.jpg)

### Components

| Layer | Technology | AWS Services |
|-------|------------|--------------|
| **Frontend** | React + Nginx (Docker) | EC2 (Private Subnet) |
| **Backend** | Spring Boot (Docker) | EC2 (Private Subnet) |
| **Database** | MySQL 8 | RDS (Private Subnet) |
| **Load Balancer** | Application Load Balancer | ALB (Public Subnets) |
| **Container Registry** | Docker Images | Amazon ECR |
| **CI/CD Engine** | Jenkins | EC2 (Public Subnet, CI/CD VPC) |
| **Remote Execution** | Agentless deploy | AWS SSM Run Command |

---

## 2) Infrastructure as Code (Terraform)

All AWS infrastructure is defined and provisioned using Terraform, organized into a single
root module covering networking, compute, load balancing, container registry, database, and IAM.

### 2.1 Networking (VPC)

Two separate VPCs are provisioned to isolate application workloads from CI/CD infrastructure:

**App VPC** — hosts all application-tier resources:
- 2 public subnets (ALB only) + 4 private subnets (Frontend/Backend EC2, RDS)
- 1 Internet Gateway + 1 NAT Gateway for outbound internet access from private subnets

**CI/CD VPC** — hosts Jenkins:
- 1 public subnet with Internet Gateway

### 2.2 Security Groups

| Security Group | Inbound Rules |
|---|---|
| `loadbalancer-sg` | TCP 80 from `0.0.0.0/0` |
| `frontend-sg` | TCP 80 from `loadbalancer-sg` only |
| `backend-sg` | TCP 5000 from `loadbalancer-sg` only |
| `database-sg` | TCP 3306 from `backend-sg` only |
| `jenkins-sg` | TCP 22 + TCP 8080 from `0.0.0.0/0` |

### 2.3 Load Balancing (ALB)

- Internet-facing ALB spanning both public subnets
- HTTP listener on port 80 with two routing rules:
  - `path_pattern = /api/*` → `backend-tg` (port 5000)
  - `path_pattern = /*` → `frontend-tg` (port 80)
- Frontend and Backend EC2 private IPs registered directly to their target groups

### 2.4 Compute (EC2)

| Instance | Subnet |
|---|---|
| `frontend` | Private (App VPC) |
| `backend` | Private (App VPC) |
| `jenkins` | Public (CI/CD VPC) |

All instances are bootstrapped via `user_data` scripts and attached an IAM Instance Profile
granting ECR pull and SSM access. Jenkins additionally has a key pair for SSH access.

### 2.5 Container Registry (ECR)

Two repositories provisioned:
- `${project_name}/frontend`
- `${project_name}/backend`

Both have `scan_on_push = true` and a lifecycle policy retaining the last 5 images.

### 2.6 Database (RDS MySQL 8)

- Placed in a private DB subnet group
- Storage encrypted, 7 day backup retention
- Port 3306 accessible from `backend-sg` only

### 2.7 IAM

- **`app-ec2-role`** (Frontend & Backend): ECR pull + SSM agent permissions
- **`jenkins-role`** (Jenkins): ECR push/pull + SSM `SendCommand` permissions

---

## 3) CI/CD (Jenkins)

Jenkins runs on a EC2 instance and orchestrates the full
build-test-deploy pipeline via a declarative `Jenkinsfile` at the repository.

### 3.1 Pipeline Overview

```
Code Push → Build (hand-on) → Jenkins → Build & Test → Push ECR → Deploy via SSM
```