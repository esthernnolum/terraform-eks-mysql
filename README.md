# Set up a K8s cluster in AWS, ECR, and MySQL Database using Terraform.

# Infrastruture diagram for the setup

![alt text](https://github.com/esthernnolum/terraform-eks-mysql/blob/main/infra-diagram.png?raw=true)

1. GitHub: hosting our terraform files.

2. Linux server is essential for setting up the infrastructure as code and should meet the prerequisites: Git, Terraform, and AWS CLI need to be installed on it.

3. Terraform plays a central role as our infrastructure-as-code tool, allowing us to provision the necessary infrastructure on the cloud through code.

4. The AWS Cloud platform where all our infrastructure resources are provisioned.

# Infrastruture setup
## Prerequisite
1. You need an AWS account with the necessary authorization to generate resources such as EKS, VPC, subnets, ECR, and MySQL.
2. Linux server with git, terraform and aws cli installed

# Steps to Reproduce this setup

### Step 1: Login to your device that has git, terraform and AWS CLI installed and configured.
Use the commands below to confirm that these are installed
For Terraform
```
terraform --version
```
For aws cli
```
aws --version
```
Fot git
```
git --version
```
### Step 2: Clone this repository to access the terraform files
```
git clone https://github.com/esthernnolum/terraform-eks-mysql.git
```
### Step 3: Initialize, Plan, and Apply terraform configuration within your project directory.
first cd in to the project folder:
```
cd terraform-eks-mysql
```
Run the below command to get the Terraform project initialized.
```
terraform init
```
To review the changes that will occur when creating resources, use the following command:
```
terraform plan
```
Execute the apply command below to generate AWS resources.
```
terraform apply
```
Terraform will present the modifications that are set to be applied to your AWS cloud infrastructure. To proceed and apply these changes, simply type "yes" and hit Enter. You can also employ the AWS CLI or utilize the AWS Management Console to confirm that the resources have been created as intended.

# Assumptions
1. Proficiency in Linux, Terraform commands, GitOps, and DevOps practices.
2. Git, terraform and aws cli already installed on client device
3. Aws cli configured with default region set to us-east-1

# Considerations Made

1. The Principle of Least Privilege has been taken into account when defining the policies for the IAM role assigned to the cluster.
2. Public access to the MySQL database has been turned off.
3. To ensure both high availability and fault tolerance, instances have been duplicated across multiple availability zones (us-east-1a, us-east-1b, us-east-1c) within the same region.