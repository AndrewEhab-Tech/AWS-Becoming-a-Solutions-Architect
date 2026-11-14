# Project 4: Hybrid Cloud Connectivity with Transit Gateway and Site-to-Site VPN

## 📋 Project Summary
- **Architecture:** Enterprise Hybrid Cloud & Multi-VPC Network
- **Author:** AWS Solutions Architect Associate Candidate
- **Course Supervisor:** Eng. Ayman Aly Mahmoud (ayman@manara.tech)

---

## 🏗 Architecture Diagram
```mermaid
graph TD
    subgraph OnPremises [On-Premises Corporate DC - 192.168.0.0/16]
        CGW[Customer Gateway CGW]
        OnPremDNS[Internal DNS Server]
    end

    CGW == Dual IPsec Tunnels + BGP ==> VPN[AWS Site-to-Site VPN Connection]
    VPN ==> TGW[AWS Transit Gateway Hub]

    subgraph AWSCloud [AWS Multi-VPC Spoke Environment]
        TGW --> InspectVPC[Inspection VPC & Network Firewall 10.100.0.0/16]
        TGW --> DevVPC[Dev VPC 10.10.0.0/16]
        TGW --> StageVPC[Staging VPC 10.20.0.0/16]
        TGW --> ProdVPC[Production VPC 10.30.0.0/16]
        
        R53Inbound[Route 53 Resolver Inbound Endpoint]
        R53Outbound[Route 53 Resolver Outbound Endpoint]
    end

    OnPremDNS -. Forward .aws queries .-> R53Inbound
    R53Outbound -. Forward .corp queries .-> OnPremDNS
    RAM[AWS Resource Access Manager] -. Share TGW across accounts .-> TGW
```

*Editable Draw.io diagram file is located at `architecture/architecture-diagram.drawio`.*

---

## ⚙️ Key AWS Services & Rationale
1. **AWS Transit Gateway (TGW):** Acts as a high-throughput central network hub, replacing complex full-mesh VPC Peering (`N*(N-1)/2`) with a scalable hub-and-spoke model.
2. **Site-to-Site VPN with BGP:** Dual tunnels over distinct AWS endpoints with dynamic route failover (Autonomous System Number 64512).
3. **Route 53 Resolver (Split-Horizon DNS):** Inbound endpoints allow on-premise hosts to resolve private AWS `.internal` domains, while Outbound endpoints forward corporate `.corp` queries to on-premise Active Directory.
4. **AWS Network Firewall:** Centrally placed in an inspection VPC to perform stateful East-West (VPC-to-VPC) and North-South (egress to internet) deep packet inspection.
5. **Direct Connect vs VPN Decision Matrix:** VPN provides rapid setup and low cost over public internet (encrypted IPsec). Direct Connect provides consistent 1G/10G/100G dedicated links for mission-critical low-jitter enterprise workloads.

---

## 🚀 Step-by-Step Deployment Guide

### Option A: Terraform Deployment
```bash
cd 04-hybrid-connectivity-transit-gateway-vpn/terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### Option B: AWS Console Deployment Steps
1. Create 3 Spoke VPCs: Dev (`10.10.0.0/16`), Staging (`10.20.0.0/16`), and Prod (`10.30.0.0/16`).
2. Create Transit Gateway with Amazon Side ASN `64512`.
3. Create Transit Gateway Attachments for each VPC selecting the appropriate subnets.
4. Set up Customer Gateway with on-premises Public IP.
5. Create Site-to-Site VPN connection attached to Transit Gateway with Dynamic (BGP) routing.
6. Configure Route 53 Inbound and Outbound Endpoints in dedicated subnets.

---

## 🧪 Testing & Validation Runbook
1. **BGP Tunnel State Check:**
   - AWS Console -> VPC -> Site-to-Site VPN Connections -> Verify Tunnel 1 Status: **UP**.
2. **Inter-VPC & Hybrid Ping / Traceroute:**
   - Ping from simulated on-premise host (`192.168.1.10`) to Prod EC2 (`10.30.1.50`).
   - Run `traceroute 10.30.1.50` to verify hops navigate through the Transit Gateway ENI interface.
3. **Split-Horizon DNS Lookup:**
   - `nslookup db.prod.aws.internal` from on-prem host -> Resolves accurately via Route 53 Resolver Inbound IP.

---

## 🧹 Clean-Up (Teardown)
```bash
cd terraform
terraform destroy -auto-approve
```
