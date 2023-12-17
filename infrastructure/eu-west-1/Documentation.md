# Networking

This section provides an overview of the networking configuration:

## VPC

- **CIDR**: 10.0.0.0/16

## Public Subnets

| Subnet      | CIDR          |
|-------------|---------------|
| subnet-1a   | 10.0.4.0/24   |
| subnet-1b   | 10.0.5.0/24   |
| subnet-1c   | 10.0.6.0/24   |

## Private Subnets

| Subnet      | CIDR          |
|-------------|---------------|
| subnet-1a   | 10.0.1.0/24   |
| subnet-1b   | 10.0.2.0/24   |
| subnet-1c   | 10.0.3.0/24   |

- 1 Internet Gateway attached to the VPC
- 1 NAT Gateway attached to a public subnet

## Route Tables

| Subnet Type      | Destination  | Target           |
|------------------|--------------|------------------|
| Public Subnets   | 0.0.0.0/0    | Internet Gateway |
| Private Subnets  | 0.0.0.0/0    | NAT Gateway      |

Default rules for local routing also apply. This networking architecture allows outbound access from the nodes but not inbound.

# Security Groups

This section covers security group configurations:

## EKS Control Plane Security Group

- Inbound: Open
- Outbound: Open

## EKS Cluster Security Group

- Inbound: HTTPS (443) Open (From Node Security Group)
- Outbound: Closed

## EKS Node Shared Security Group

### Inbound

| Port    | Description                               |
|---------|-------------------------------------------|
| 53      | Node to node CoreDNS UDP                  |
| 10250   | Cluster API to node kubelets              |
| 3000-8080 | Target Group Binding for ALB           |
| 1025-65535 | Node to node ingress on ephemeral ports |
| 4443    | Cluster API to node 4443/tcp webhook     |
| 9443    | Cluster API to node 9443/tcp webhook     |
| 6443    | Cluster API to node 6443/tcp webhook     |
| 8443    | Cluster API to node 8443/tcp webhook     |
| 443     | Cluster API to node groups                |

### Outbound

- Open

# Amazon ECR (Elastic Container Registry)

Two ECR repositories have been created to host containers:

1. gaf-ecr-be
2. gaf-ecr-fe

The following policies were applied to enable nodes to pull from these repositories:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "new policy",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<account>:role/eks-managed-group-eks-node-group-"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchDeleteImage",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DeleteRepository",
        "ecr:DeleteRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:SetRepositoryPolicy",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
```

Dependencies and integration are managed by `terraform apply`.

# IAM (Identity and Access Management)

A user named `eks-poweruser` has been created with the managed policy `arn:aws:iam::aws:policy/PowerUserAccess` for cluster accessibility.

# Route53

A new hosted zone is created, allowing you to add a record pointing to the load balancer created by the cluster.
