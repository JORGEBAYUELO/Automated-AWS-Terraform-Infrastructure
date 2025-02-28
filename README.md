
This project automates the setup of a basic AWS infrastructure using Terraform. It provisions an Amazon EC2 instance running NGINX, secures it with a security group, and uses S3 for state management with DynamoDB for state locking.

## Project Overview

The objective is to deploy and manage AWS resources using Terraform while maintaining best practices such as remote state management and locking.

### What This Project Includes:

1. **EC2 Instance**: An Amazon Linux instance with NGINX installed via user data.
    
2. **S3 Bucket**: Stores the Terraform state file.
    
3. **DynamoDB Table**: Provides state locking to prevent concurrent operations.
    
4. **Security Group**: Allows inbound SSH (22) and HTTP (80) traffic.    

## Prerequisites

Ensure you have the following set up before proceeding:

- AWS account
    
- Terraform installed (>= 1.0.0)
    
- AWS CLI installed and configured    

## Step 1: AWS Console Pre-Configuration

1. **Create an AWS Key Pair**:
    
    - Go to the AWS Console -> EC2 Dashboard.
        
    - Create a key pair (e.g., `MyKeyPair`).
        
    - Download and securely store the `.pem` file.
        
2. **Create the S3 Bucket for State Storage**:
    
    - Navigate to the S3 service and create a new bucket.
        
    - Ensure the bucket name is globally unique (e.g., `my-terraform-bucket-storage`).
        
3. **Create the DynamoDB Table for State Locking**:
    
    - Go to the DynamoDB service.
        
    - Create a table with:
        
        - Table name: `terraform-lock`
            
        - Partition key: `LockID` (Type: String)            

## Step 2: Set Up AWS CLI

Configure the AWS CLI to authenticate with your AWS account:

```
aws configure
```

Input your AWS Access Key, Secret Key, default region, and output format.

## Step 3: Project Structure

Ensure your Terraform project is structured as follows:

```
.
├── modules
│   └── s3
│        └── main.tf
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
└── user_data.sh
```

### Key Files:

- `backend.tf`: Configures the remote backend (S3 + DynamoDB).
    
- `main.tf`: Defines AWS resources (EC2, Security Group).
    
- `user_data.sh`: Script to install NGINX on instance launch.    

## Step 4: Configure the Terraform Files

### `backend.tf`

```
terraform {
  backend "s3" {
    bucket         = "my-terraform-bucket-storage"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
```

### `main.tf`

```
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-053a45fff0a704a47" # Amazon Linux 2023
  instance_type          = "t2.micro"
  key_name              = "MyKeyPair"
  user_data             = file("${path.module}/user_data.sh")
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### `user_data.sh`

```
#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
```

## Step 5: Initialize and Deploy Infrastructure

1. **Initialize Terraform**:
    

```
terraform init
```

1. **Validate the Configuration**:
    

```
terraform validate
```

1. **Create an Execution Plan**:
    

```
terraform plan
```

1. **Apply the Changes**:
    

```
terraform apply
```

Confirm with `yes` when prompted.

## Step 6: Verify the Deployment

1. **SSH into the Instance**:
    

```
ssh -i /path/to/MyKeyPair.pem ec2-user@<PUBLIC_IP>
```

1. **Check NGINX Status**:
    

```
systemctl status nginx
```

1. **Access NGINX via Browser**:
    

Visit `http://<PUBLIC_IP>` in your browser—you should see the NGINX welcome page.

## Step 7: Clean Up Resources

When you're done, destroy all resources to avoid unnecessary costs:

```
terraform destroy
```

Confirm with `yes` when prompted.

## Best Practices

1. **Secure Credentials**: Never store AWS credentials in your Terraform files. Use environment variables instead.
    
2. **Remote State**: Use S3 and DynamoDB for safe state storage and locking.
    
3. **Automation**: Consider CI/CD pipelines for automated deployments.    

## Lessons Learned

- How to provision AWS resources using Terraform.
    
- Importance of remote state and locking for collaborative workflows.
    
- Configuring EC2 instances with user data for automatic setup.
    
- Managing AWS resources effectively using infrastructure-as-code principles.




