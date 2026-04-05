# 🚀 Automation Deployment – Monolithic Application

## 🛠️ Tech Stack & Skills Demonstrated

<div align="center">

![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&ogoColor=white) ![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) ![Amazon EC2](https://img.shields.io/badge/Amazon_EC2-FF9900?style=flat&logo=amazonaws&logoColor=white) ![Amazon ECR](https://img.shields.io/badge/Amazon_ECR-FF9900?style=flat&logo=amazonaws&logoColor=white) ![Amazon RDS](https://img.shields.io/badge/Amazon_RDS-527FFF?style=flat&logo=amazonrds&logoColor=white) ![ECS](https://img.shields.io/badge/ECS-d96b1a?style=flat) ![ALB](https://img.shields.io/badge/ALB-693cc5?style=flat) ![IAM](https://img.shields.io/badge/IAM-ff7f93?style=flat)
![ASG](https://img.shields.io/badge/Autoscaling-d8762e?style=flat) ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white)

</div>

---

## 🔧 Infrastructure & Delivery Approaches

| Item | Detail |
|---|---|
| **IaC** | Terraform |
| **CI/CD** | Jenkins |
| **Container Registry** | Amazon ECR |
| **Container Orchestration** | ECS |
| **Cloud Provider** | AWS |

---

## 1) System Architecture

![System Architecture](./docs/images/architecture.svg)

### Components

| Layer | Technology | AWS Services |
|-------|------------|--------------|
| **Frontend** | React (Docker) | ECS Service (Private Subnet) |
| **Backend** | Spring Boot (Docker) | ECS Service (Private Subnet) |
| **Database** | MySQL 8 | RDS (Private Subnet) |
| **Load Balancer** | Application Load Balancer | ALB (Public Subnets \| 2-AZ) |
| **Container Registry** | Docker Images | Amazon ECR |
| **CI/CD Engine** | Jenkins | EC2 (Public Subnet, CI/CD VPC) |
| **Container Orchestration** | ECS Cluster + EC2 (ECS-Optimized AMI) | ECS |
| **Auto Scaling** | ECS Service Auto Scaling | Application Auto Scaling |

### ECS Architecture

ECS runs in EC2 launch type mode using ECS-Optimized AMIs. Each EC2 instance registers itself to the ECS Cluster via the ECS Agent bundled in the AMI. Container workloads are scheduled as ECS Services with Task Definitions referencing images from ECR.

```
ECR (Images)
    │
    ▼
ECS Cluster (EC2 Launch Type)
    ├── ECS Service: Frontend  ──► Task Definition (React Container)
    │       └── Registered to frontend-target (ALB)
    └── ECS Service: Backend   ──► Task Definition (NodeJS Container)
            └── Registered to backend-target (ALB)
```

- **ECS Cluster**: Groups all EC2 container instances within the App VPC private subnets
- **Task Definitions**: Declare container image (from ECR), CPU/memory, port mappings, environment variables, and log configuration (CloudWatch)
- **ECS Services**: Maintain desired task count, handle rolling deployments, and register tasks into ALB target groups
- **Auto Scaling**: Application Auto Scaling adjusts ECS service desired count based on CPU/memory metrics

---

## 2) Infrastructure as Code (Terraform)

All AWS infrastructure is defined and provisioned using Terraform, organized into a single
root module covering networking, compute, load balancing, container registry, database, and IAM.

### 2.1 Networking (VPC)

Two separate VPCs are provisioned to isolate application workloads from CI/CD infrastructure:

**App VPC** — hosts all application-tier resources:
- 2 public subnets (ALB only) + 4 private subnets (ECS EC2 instances, RDS)
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
  - `path_pattern = /api/*` → `backend-target` (port 5000)
  - `path_pattern = /*` → `frontend-target` (port 80)
- ECS tasks registered dynamically to target groups via the ALB role

### 2.4 Compute (EC2)

| Instance | Subnet |
|---|---|
| `ECS EC2 Infrastructure` | Private (App VPC) |
| `jenkins` | Public (CI/CD VPC) |

EC2 instances use the ECS-Optimized AMI which bundles the ECS Agent and Docker runtime. Each instance attaches the `instance-profile` (see IAM section) to enable ECR pull, ECS registration, SSM access, and CloudWatch metrics.

Jenkins instance is bootstrapped via `user_data` scripts which install Docker and the Jenkins agent, and attaches the `jenkins-profile` granting ECR push, Task Definations Revision and Update ECS Service.

### 2.5 Container Registry (ECR)

Two repositories provisioned:
- `${project_name}/frontend`
- `${project_name}/backend`

Both have `scan_on_push = true` and a lifecycle policy retaining the last 5 images.

### 2.6 Database (RDS MySQL 8)

- Placed in a private DB subnet group
- Storage encrypted, 7-day backup retention
- Port 3306 accessible from `backend-sg` only

### 2.7 IAM

Four IAM roles are provisioned to enforce least-privilege access across the infrastructure:

#### `instance-role` (ECS EC2 Instances)

Attached to all EC2 instances running ECS workloads (Frontend & Backend). Grants:

| Permission | Source |
|---|---|
| ECR pull (`BatchGetImage`, `GetDownloadUrlForLayer`, etc.) | Inline policy — scoped to `${project_name}/*` repositories |
| ECR authorization token | Inline policy — `ecr:GetAuthorizationToken` |
| ECS Agent registration & task management | Managed policy: `AmazonEC2ContainerServiceforEC2Role` |
| ECS service role actions | Managed policy: `AmazonEC2ContainerServiceRole` |
| SSM Session Manager & Run Command | Managed policy: `AmazonSSMManagedInstanceCore` |
| CloudWatch metrics & log publishing | Managed policy: `CloudWatchAgentServerPolicy` |

#### `jenkins-role` (Jenkins EC2)

Attached to the Jenkins instance. Grants:

| Permission | Source |
|---|---|
| ECR push/pull (full image lifecycle) | Inline policy — all ECR actions on `*` |
| SSM `SendCommand` to trigger deployments on ECS instances | Inline policy — `ssm:SendCommand`, `ssm:GetCommandInvocation`, etc. |

#### `auto_scaling_role` (ECS Application Auto Scaling)

Used by Application Auto Scaling to scale ECS service desired count. Grants:

| Permission | Source |
|---|---|
| ECS scaling actions | Managed policy: `AmazonEC2ContainerServiceAutoscaleRole` |

#### `alb_role` (ECS ↔ ALB Integration)

Assumed by `ecs.amazonaws.com` to allow ECS to register/deregister tasks in ALB target groups. Grants:

| Permission | Source |
|---|---|
| EC2 security group & describe operations | Inline policy |
| ELB target group registration/deregistration | Inline policy — scoped to `targetgroup/*/*` |
| ALB/NLB listener & rule modification | Inline policy — scoped to listener/rule ARN patterns |

> Equivalent to the AWS managed policy `AmazonECSInfrastructureRolePolicyForLoadBalancers`.

---

## 3) CI/CD (Jenkins)

Jenkins runs on an EC2 instance and orchestrates the full
build-test-deploy pipeline via a declarative `Jenkinsfile.frontend` for the FE and `Jenkinsfile.backend` for the BE at the repository.

### 3.1 Pipeline Overview

```
Code Push → Start Build (hand-on) → Jenkins → Pull → Build & Test → Push ECR → Update Task Definition → Update Service
```

### 3.2 Blue/Green Deployment

ECS services use the native **BLUE_GREEN** deployment strategy (`deployment_configuration.strategy = "BLUE_GREEN"`), managed directly by ECS without CodeDeploy.

Each service maintains two target groups behind the ALB listener rule:

| Service | Blue TG | Green TG |
|---|---|---|
| Frontend | `frontend-tg-blue` | `frontend-tg-green` |
| Backend | `backend-tg-blue` | `backend-tg-green` |

**Flow:**

```
Jenkins pushes new image to ECR → Updates ECS Task Definition
              │
              ▼
ECS launches new tasks → registers to Green TG
              │
              ▼
ALB shifts 100% traffic: Blue → Green
              │
              ▼
Bake time (30 min) — ECS monitors health
              │
        ┌─────┴─────┐
      Healthy      Unhealthy
        │              │
        ▼              ▼
   Blue drained    Auto rollback
   (standby)      to Blue TG
```

The `alb_role` grants ECS permission to modify ALB listener rules and swap target group registration automatically. On the next deployment, the roles reverse — Green becomes standby and Blue receives the new version.
