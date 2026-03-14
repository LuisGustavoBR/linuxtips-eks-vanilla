# LinuxTips EKS Vanilla Cluster

This repository contains Terraform configurations to deploy a minimal Amazon EKS (Elastic Kubernetes Service) cluster following LinuxTips best practices.

## Overview

This project creates a production-ready EKS cluster with:
- **EKS Cluster** with encryption and logging enabled
- **Managed Node Groups** with auto-scaling
- **IAM Roles** for cluster and nodes with proper permissions
- **VPC Integration** using existing subnets via SSM parameters
- **Security Groups** for proper network isolation
- **KMS Encryption** for secrets
- **OIDC Provider** for service account integration
- **Essential Add-ons** (CNI, CoreDNS, Kube-Proxy)
- **Monitoring Stack** (Metrics Server, Kube State Metrics)

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   EKS Cluster   │    │  Managed Nodes  │
│                 │    │                 │
│ • Control Plane │    │ • Auto Scaling  │
│ • Encryption    │    │ • Spot Support  │
│ • Logging       │    │ • IAM Roles     │
│ • OIDC          │    │ • Security      │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────────────────┘
                 │
        ┌─────────────────┐
        │     VPC         │
        │                 │
        │ • Private Subs  │
        │ • Public Subs   │
        │ • Pod Subs      │
        │ • NAT Gateway   │
        └─────────────────┘
```

## Quick Start

### Prerequisites

- **AWS CLI** configured with appropriate permissions
- **Terraform** >= 1.0.0
- **kubectl** for cluster access
- **Existing VPC** with subnets stored in SSM Parameter Store

### Required AWS Permissions

Your AWS user/role needs these permissions:
- EKS full access
- EC2 full access
- IAM full access
- VPC/Subnet access
- KMS access
- SSM Parameter Store access

### Deployment Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/LuisGustavoBR/linuxtips-eks-vanilla.git
   cd linuxtips-eks-vanilla
   ```

2. **Configure your environment**
   ```bash
   cd environment/prod
   cp terraform.tfvars terraform.tfvars.backup
   # Edit terraform.tfvars with your values
   ```

3. **Initialize Terraform**
   ```bash
   terraform init --backend-config=environment/prod/backend.tfvars
   ```

4. **Plan the deployment**
   ```bash
   terraform plan --var-file=environment/prod/terraform.tfvars
   ```

5. **Apply the configuration**
   ```bash
   terraform apply --var-file=environment/prod/terraform.tfvars
   ```

6. **Configure kubectl**
   ```bash
   aws eks update-kubeconfig --name linuxtips-cluster --region us-east-1
   ```

7. **Verify the cluster**
   ```bash
   kubectl get nodes
   kubectl get pods -A
   ```

## Project Structure

```
├── 📄 access_entries.tf      # EKS Access Entries for authentication
├── 📄 addons.tf              # EKS Add-ons (CNI, CoreDNS, etc.)
├── 📄 assets/                # Kubernetes manifests and configs
├── 📄 aws_auth.tf            # ConfigMap for node authentication
├── 📄 backend.tf             # Terraform backend configuration
├── 📄 data.tf                # Data sources for VPC and subnets
├── 📄 eks.tf                 # Main EKS cluster configuration
├── 📄 environment/           # Environment-specific configurations
│   └── prod/
│       ├── backend.tfvars    # Backend configuration
│       └── terraform.tfvars  # Production variables
├── 📄 helm_*.tf              # Helm releases for monitoring
├── 📄 iam_*.tf               # IAM roles and policies
├── 📄 kms.tf                 # KMS key for encryption
├── 📄 nodes.tf               # EKS Managed Node Groups
├── 📄 oidc.tf                # OIDC provider for service accounts
├── 📄 outputs.tf             # Terraform outputs
├── 📄 provider.tf            # AWS and Kubernetes providers
├── 📄 sg.tf                  # Security groups
└── 📄 variables.tf           # Input variables
```

## ⚙️ Configuration

### Main Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `project_name` | Cluster name | `"linuxtips-cluster"` |
| `region` | AWS region | `"us-east-1"` |
| `k8s_version` | Kubernetes version | `"1.34"` |
| `auto_scale_options` | Node scaling config | `{min=2, max=5, desired=2}` |
| `nodes_instance_sizes` | EC2 instance types | `["t3.large"]` |

### SSM Parameters Required

The VPC infrastructure must be pre-created and stored in SSM:

```
/linuxtips-vpc/vpc/id
/linuxtips-vpc/subnets/private/us-east-1a/linuxtips-private-1a
/linuxtips-vpc/subnets/private/us-east-1b/linuxtips-private-1b
/linuxtips-vpc/subnets/private/us-east-1c/linuxtips-private-1c
/linuxtips-vpc/subnets/public/us-east-1a/linuxtips-public-1a
/linuxtips-vpc/subnets/public/us-east-1b/linuxtips-public-1b
/linuxtips-vpc/subnets/public/us-east-1c/linuxtips-public-1c
/linuxtips-vpc/subnets/private/us-east-1a/linuxtips-pods-1a
/linuxtips-vpc/subnets/private/us-east-1b/linuxtips-pods-1b
/linuxtips-vpc/subnets/private/us-east-1c/linuxtips-pods-1c
```

## Features

### Security
- ✅ **Encryption at rest** for Kubernetes secrets
- ✅ **IAM roles** with least privilege
- ✅ **Private subnets** for worker nodes
- ✅ **Security groups** for network isolation
- ✅ **OIDC provider** for secure service accounts

### Scalability
- ✅ **Auto-scaling** node groups
- ✅ **Multiple AZs** for high availability
- ✅ **Spot instances** support
- ✅ **Pod subnets** for network optimization

### Monitoring
- ✅ **CloudWatch logging** for control plane
- ✅ **Metrics Server** for resource monitoring
- ✅ **Kube State Metrics** for detailed metrics
- ✅ **Zonal shift** configuration

### Networking
- ✅ **VPC CNI** for pod networking
- ✅ **CoreDNS** for service discovery
- ✅ **Kube-Proxy** for network policies
- ✅ **NodePort services** access

## Troubleshooting

### Common Issues

**1. Node group creation fails**
```bash
# Check cluster status
aws eks describe-cluster --name linuxtips-cluster

# Verify IAM permissions
aws sts get-caller-identity
```

**2. kubectl connection issues**
```bash
# Update kubeconfig
aws eks update-kubeconfig --name linuxtips-cluster --region us-east-1

# Check cluster connectivity
kubectl cluster-info
```

**3. Access entry conflicts**
```bash
# Import existing access entry
terraform import aws_eks_access_entry.nodes linuxtips-cluster:arn:aws:iam::ACCOUNT:role/ROLE
```

### Useful Commands

```bash
# Check cluster health
kubectl get componentstatuses

# View node status
kubectl get nodes -o wide

# Check pod status
kubectl get pods -A

# View cluster events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check terraform state
terraform state list
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Use descriptive commit messages
- Update documentation for new features
- Test changes in a development environment
- Follow Terraform best practices
- Use conventional commit format

## Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [LinuxTips YouTube Channel](https://www.youtube.com/c/LinuxTips)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This is a learning project from LinuxTips training. Use at your own risk in production environments. Always test thoroughly before deploying to production.