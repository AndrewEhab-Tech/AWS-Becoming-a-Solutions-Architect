# AWS Solutions Architect - Associate (SAA-C03) Graduation Projects Suite
### Complete Portfolio of 8 Production-Grade AWS Solution Architectures
**Author:** AWS Solutions Architect Associate Candidate  
**Course Supervisor:** Eng. Ayman Aly Mahmoud ([ayman@manara.tech](mailto:ayman@manara.tech)) | [LinkedIn Profile](https://www.linkedin.com/in/ayman-mahmoud/)  

---

## 🎯 Portfolio Overview
This repository contains end-to-end, production-grade implementations of the **8 AWS Solutions Architect Associate (SAA-C03) Graduation Projects**. Each project follows the official **AWS Solutions Library** architectural and documentation standards, including:
1. **Interactive Solution Architecture Diagrams** (Draw.io `.drawio` source files and Mermaid diagrams in markdown).
2. **Complete Infrastructure as Code (Terraform)** with validated modules (`main.tf`, `variables.tf`, `outputs.tf`).
3. **Application & Microservice Source Code** (Node.js, Python Lambdas, Shell bootstrap scripts, SQL queries).
4. **Step-by-Step Deployment Runbooks** for both automated Terraform and manual AWS Console deployment.
5. **Testing & Failure Simulation Runbooks** (Auto-Healing, Multi-AZ Failover, Threat Injection, etc.).
6. **AWS Well-Architected Framework Reviews** and Resource Teardown Guides.

---

## 📚 Projects Catalog & Matrix

| # | Project Title | Architecture Domain | Primary AWS Services | Cost / Complexity | Folder Link |
| :-: | :--- | :--- | :--- | :--- | :--- |
| **01** | **Scalable Web App with ALB & Auto Scaling** | EC2 & Compute | ALB, ASG, Multi-AZ RDS, CloudFront, WAF, SSM | Moderate / Classic SAA | [Open Project 01](./01-scalable-web-app-alb-asg) |
| **02** | **Serverless Image Processing Pipeline** | Serverless EDA | S3, SQS + DLQ, Lambda, Step Functions, DynamoDB | Low (Free Tier) / High Value | [Open Project 02](./02-serverless-image-processing-pipeline) |
| **03** | **Serverless REST API with Cognito & WAF** | Serverless Microservices | API Gateway, Cognito, DynamoDB, Lambda, X-Ray | Low (Free Tier) / Enterprise | [Open Project 03](./03-serverless-rest-api-cognito-dynamodb) |
| **04** | **Hybrid Cloud with Transit Gateway & VPN** | Networking | Transit Gateway, Site-to-Site VPN, Multi-VPC, Route 53 Resolver | Moderate / Advanced Net | [Open Project 04](./04-hybrid-connectivity-transit-gateway-vpn) |
| **05** | **Multi-Region Disaster Recovery with Route 53** | Hybrid / DR | Route 53 Failover, Aurora Global DB, S3 CRR, EventBridge | High / Mission Critical | [Open Project 05](./05-multi-region-dr-route53-failover) |
| **06** | **Containerized Microservices on ECS Fargate** | Containers | ECS Fargate, ECR, Cloud Map, ALB Path-Routing, Redis | Moderate / DevOps Focused | [Open Project 06](./06-containerized-microservices-ecs-fargate) |
| **07** | **Serverless Data Lake & Analytics Pipeline** | Big Data & Analytics | Kinesis Firehose, S3 3-Zone, Glue ETL, Athena, QuickSight | Low-Moderate / Modern Data | [Open Project 07](./07-serverless-data-lake-analytics-glue-athena) |
| **08** | **Secure Multi-Tier Architecture with GuardDuty** | Cloud Security & SecOps | KMS CMK, Secrets Manager, GuardDuty, Security Hub, Config | Low-Moderate / Defense-in-Depth | [Open Project 08](./08-secure-multi-tier-guardduty-kms-securityhub) |

---

## 🏆 Recommended Project for Graduation Submission
While all 8 projects are fully implemented and ready for submission in this repository, for the official individual graduation deliverable to Eng. Ayman:
- **Top Choice for SAA Certification & Job Interviews:** **Project 1 (Scalable Web App with ALB and Auto Scaling)** or **Project 6 (ECS Fargate Microservices)**.
- **Top Choice for Zero AWS Cost / Free Tier:** **Project 2 (Serverless Image Pipeline)** or **Project 3 (Serverless REST API)**.

---

## 📤 Graduation Submission Deliverables Checklist
1. [x] **Solution Architecture Diagram:** Available in each project's `architecture/` folder in Draw.io format and rendered via Mermaid in each `README.md`.
2. [x] **Public GitHub Repository:** Fully documented README following the AWS Solutions standard.
3. [x] **Deployment & Testing Instructions:** Comprehensive step-by-step guides included.
4. [ ] **Demo Video / Live URL (Optional but Encouraged):** Record a 5-minute walkthrough of the architecture diagram and AWS Console test cases using Loom or YouTube.
