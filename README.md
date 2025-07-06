## 1. Overview

This Terraform configuration provisions a highly available, auto-scaling web application infrastructure on AWS. It uses Application Load Balancer (ALB) with path-based routing, two EC2 Auto Scaling Groups (ASGs), and supporting networking resources.

---

## 2. Infrastructure Components

### a. Networking

- **VPC**: A custom VPC is created with a configurable CIDR block.
- **Subnets**: Two subnets in different Availability Zones for high availability.
- **Internet Gateway**: Provides internet access to resources in the VPC.
- **Route Table**: Configured to route all outbound traffic to the Internet Gateway.
- **Route Table Associations**: Each subnet is associated with the route table.
- **Security Group**: Allows all inbound and outbound traffic (protocol and CIDR are configurable).

### b. Compute

- **AMI**: Uses the latest Amazon Linux 2 AMI.
- **Launch Templates**: Two templates, one for each application (app-1 and app-2), install and configure NGINX to serve different content and paths.
- **Auto Scaling Groups**: Two ASGs, each using a launch template and spanning both subnets. Desired, min, and max capacities are configurable.

### c. Load Balancing

- **Application Load Balancer (ALB)**: Distributes HTTP traffic across instances in both subnets.
- **Target Groups**: Two target groups, one for each application.
- **Listener & Listener Rules**: 
  - Listens on port 80.
  - Path-based routing: `/app1` routes to app-1, `/app2` routes to app-2.
  - Default action returns a 404 message.

### d. Auto Scaling Policies & Monitoring

- **Scaling Policies**: Scale out/in policies for each ASG, triggered by CloudWatch alarms.
- **CloudWatch Alarms**: 
  - Scale out when CPU > 75% (for 2 periods).
  - Scale in when CPU < 30% (for 2 periods).

---

## 3. Variables (`variable.tf`)

All major parameters are configurable, including:
- AWS region and availability zones
- VPC and subnet CIDRs
- Load balancer type
- Security group protocol
- AMI selection
- EC2 instance type
- Auto Scaling Group capacities

---

## 4. Outputs (`output.tf`)

The configuration outputs all key resource IDs and ARNs, including:
- VPC, subnet, IGW, route table, and security group IDs
- AMI ID
- Launch template IDs and ARNs
- ALB ARN and DNS name
- Target group ARNs
- Listener and listener rule ARNs
- ASG ARNs
- Scaling policy ARNs
- CloudWatch alarm ARNs

---

## 5. Application Details

- **App-1**: Served at `/app1`, NGINX serves a static HTML page.
- **App-2**: Served at `/app2`, NGINX serves a different static HTML page.

---

## 6. High Availability & Scalability

- Resources are distributed across two AZs.
- Auto Scaling ensures the number of instances adjusts based on CPU utilization.
- ALB provides fault tolerance and path-based routing.

---

## 7. Security

- Security group is open by default (protocol and CIDR are configurable).
- All resources are tagged for identification.

---