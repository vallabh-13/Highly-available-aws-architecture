
# 🏗️ Highly Available Web Architecture on AWS (Reliability Pillar)

## 📌 Project Overview

This project provisions a fault-tolerant, production-grade web hosting stack using Terraform. It includes EC2 instances behind an Auto Scaling Group and Application Load Balancer (ALB), a Multi-AZ RDS database layer, DNS failover via Route 53, and shared storage using Amazon EFS. The architecture is designed for high availability, scalability, and resilience.

---

## 🎯 Key Objectives

- 🚀 Launch Compute Layer (EC2 Auto Scaling + ALB)
- 🗄️ Deploy Database Layer (RDS Multi-AZ)
- 🌐 Set Up DNS Failover with Route 53
- 📦 Add Shared Storage with Amazon EFS
- ✅ Final Validation and Optional Extensions
- 🧹 Conclusion and Resource Cleanup

---

## 🧱 Architecture Summary

| Layer             | Components                                                                 |
|------------------|------------------------------------------------------------------------------|
| Compute           | EC2 instances in Auto Scaling Group, behind ALB                            |
| Database          | Amazon RDS (Multi-AZ, PostgreSQL/MySQL)                                    |
| Storage           | Amazon EFS mounted to EC2 instances                                         |
| Networking        | VPC with public/private subnets, NAT Gateway for outbound traffic           |
| DNS               | Route 53 hosted zone with failover routing to ALB                          |
| Monitoring        | CloudWatch metrics, ALB health checks                                       |

---

## 📁 Folder Structure (Terraform)

```

```

---

## ✅ Prerequisites

- AWS CLI authenticated to your account
- Terraform ≥ 1.3.0
- Domain registered in Route 53
- Hosted zone created `example.com`

---

## 🚀 Deployment Sequence

```bash
# Step 1: Initialize backend
terraform -chdir=state-bucket terraform init

# Step 2: Plan infrastructure
terraform -chdir=state-bucket teraform plan

# Step 3: Apply infrastructure
terraform -chdir=state-bucket apply -auto-approve
```

---

## 🔥 Teardown Sequence

```bash
# Step 1: Destroy infrastructure
terraform -chdir=environments/dev destroy -auto-approve
```

---

## 🧠 Project functioning 

- VPC module provisions public/private subnets
- NAT Gateway module enables outbound traffic from private EC2s
- EC2 module launches ASG with Apache and EFS mount
- ALB module distributes traffic and performs health checks
- RDS module provisions Multi-AZ database
- Route 53 module creates A record and failover routing
- Remote state stored in S3 with DynamoDB locking (optional)

---

## 🧩 Common Errors & Fixes

### ❌ Target Group Not Connected
**Cause**: EC2 instance not registered or health check failing  
**Fix**: Ensure Apache is running and responds with HTTP 200 on `/`. Check security group and target group health.

---

### ❌ No Internet Access in Private Subnet
**Cause**: NAT Gateway missing or route table misconfigured  
**Fix**: Confirm route table for private subnet has:
```hcl
route {
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}
```

---

### ❌ Route 53 DNS Not Resolving
**Cause**: Domain nameservers don’t match hosted zone  
**Fix**:
- Go to Route 53 → Registered Domains
- Update nameservers to match hosted zone:
  ```
  ns-1572.awsdns-04.co.uk
  ns-218.awsdns-27.com
  ns-752.awsdns-30.net
  ns-1157.awsdns-16.org
  ```

---

## 🧠 Notes

- Use `prevent_destroy` on hosted zone to avoid accidental deletion
- Validate DNS with `dig`, `nslookup`, and [dnschecker.org](https://dnschecker.org)
- Use CloudWatch alarms for ALB and EC2 health monitoring
- you should change name servers of your registered dns to name servers given by hosted zone, if you deploy hosted zone and delete it for saving cost.
---

## 🔧 What Could Be Improved

- Add CI/CD pipeline for automated deployment

- Add tagging standards for cost tracking
- Enable AWS Config for compliance monitoring
- Add CloudWatch dashboards for visibility

---

