# Label Studio AWS EKS Terraform Module
The Label Studio AWS EKS Terraform module is a tool for deploying LabelStudio on Amazon Web Services Elastic Kubernetes Service (AWS EKS). This module allows users to easily deploy and manage LabelStudio in a scalable, highly available manner using the AWS cloud and Kubernetes.

This document will provide an overview of the deployment process and the prerequisites for using the module. It will also cover the configuration options and provide step-by-step instructions for deploying LabelStudio on AWS EKS using the Terraform module. Finally, it will provide tips for testing and validating the deployment, as well as next steps for updating and modifying the deployment.

## What is Elastic Kubernetes Service(EKS)?
[Amazon Elastic Kubernetes Service](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) is a managed Kubernetes service on AWS, it gives user flexibility to run and scale Kubernetes applications in the AWS cloud.

## Prerequisites for this module

| NAME                                                         | Version | 
|--------------------------------------------------------------|---------|
| [Common prerequisites](../../README.md#Common-prerequisites) |         | 
| aws cli                                                      | 2.9.4   |

### How to install awscli

Consult the [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for specific instructions for your system.

## AWS account
You should have an AWS account and appropriate permissions to create and manage the resources required for the deployment. This includes the ability to create and manage EC2 instances, S3 buckets, and other AWS services.

<details>
  <summary>Click to expand IAM configuration</summary>

### IAM settings

Once you have created an AWS account, go to your [account](https://console.aws.amazon.com/iam/home#/security_credentials) security settings and be sure to follow these steps:

- Set a strong password
- Activate MFA for the root account
- Delete and do not create access keys for the root account

Further, in the [IAM](https://console.aws.amazon.com/iam/home#/home) console:

- In the [Policies](https://console.aws.amazon.com/iam/home#/policies) menu, create `MFASecurity` policy that prohibits users from using services without activating [MFA](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage-mfa-only.html)
- In the [Roles](https://console.aws.amazon.com/iam/home?region=us-east-1#/roles) menu, create new role `administrator`. Select *Another AWS Account* - and enter your account number in the *Account ID* field. Check the *Require MFA* checkbox. In the next *Permissions* window, attach the `AdministratorAccess` policy to it.
- In the [Policies](https://console.aws.amazon.com/iam/home#/policies) menu, create `assumeAdminRole` policy:

  ```json
  {
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::<your-account-id>:role/administrator"
    }
  }
  ```

- In the [Groups](https://console.aws.amazon.com/iam/home#/groups) menu, create the `admin` group; in the next window, attach `assumeAdminRole` and `MFASecurity` policy to it. Finish creating the group.
- In the [Users](https://console.aws.amazon.com/iam/home#/users) menu, create a user to work with AWS by selecting both checkboxes in *Select AWS access type*. In the next window, add the user to the `admin` group. Finish and download CSV with credentials.
</details>

Once these prerequisites are in place, you can proceed to the next step of configuring and deploying LabelStudio using the Terraform module.

## Configuration
There are multiple configuration examples for different use-cases to provision Label Studio/Label Studio Enterprise stored in [examples folder](examples).

The full list of available configuration variables can be found in [AWS module folder](env/README.md). 

## List of use-cases

### Label Studio with PostgresSQL Helm sub-chart

Deploy Label Studio with Bitnami's PostgreSQL database provisioned in AWS EKS.

[Full tfvars file example](examples/opensource.tfvars)

### Label Studio with AWS RDS

Deploy Label Studio with AWS RDS as database.

```hcl
postgresql_type     = "rds"
postgresql_database = "<REPLACE_ME>"
postgresql_username = "<REPLACE_ME>"
```

[Full tfvars file example](examples/opensource_rds.tfvars)

### Label Studio with external PostgreSQL

Deploy Label Studio connected to the external postgresql database(e.g. already provisioned).

```hcl
postgresql_type     = "external"
postgresql_database = "<REPLACE_ME>"
postgresql_host     = "<REPLACE_ME>"
postgresql_port     = "<REPLACE_ME>"
postgresql_username = "<REPLACE_ME>"
postgresql_password = "<REPLACE_ME>"
```

[Full tfvars file example](examples/opensource_external_postgresql.tfvars)

### Label Studio with external PostgreSQL with SSL

Deploy Label Studio connected to the external postgresql database with SSL(e.g. already provisioned).

```hcl
postgresql_type     = "external"
postgresql_database = "<REPLACE_ME>"
postgresql_host     = "<REPLACE_ME>"
postgresql_port     = "<REPLACE_ME>"
postgresql_username = "<REPLACE_ME>"
postgresql_password = "<REPLACE_ME>"
postgresql_ssl_mode = "verify-ca"
postgresql_tls_key_file = "<REPLACE_ME>/postgres.key"
postgresql_tls_crt_file = "<REPLACE_ME>/postgres.crt"
postgresql_ca_crt_file = "<REPLACE_ME>/postgresCA.crt"
```

[Full tfvars file example](examples/opensource_external_postgresql_ssl.tfvars)

### Label Studio with domain name

Deploy and assign domain name with singed by Let's Encrypt certificate using cert-manager.

If you already have Hosted Zone, set `create_r53_zone` to `false`.

```hcl
create_r53_zone = false
domain_name     = "example.com"
record_name     = "label-studio"
email           = "test@test.com"
```

[Full tfvars file example](examples/opensource_route53.tfvars)

### Label Studio with predefined VPC

Deploy to existing VPC.

```hcl
predefined_vpc_id = "vpc-***"
```

[Full tfvars file example](examples/opensource_predefined_vpc.tfvars)

### Label Studio Enterprise

Deploy a Label Studio Enterprise with ElastiCache and RDS.

```hcl
enterprise                  = true
license_literal             = "<REPLACE_ME>"
registry_username           = "<REPLACE_ME>"
registry_password           = "<REPLACE_ME>"
label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio-enterprise"
  "global.image.tag"        = "<REPLACE_ME>"
}
```

[Full tfvars file example](examples/enterprise.tfvars)

### Label Studio Enterprise with external Redis

Deploy a Label Studio Enterprise with external Redis(e.g. already provisioned).

```hcl
redis_type = "external"
redis_host = "redis://<SECRET>:<SECRET>/1"
redis_password = "<SECRET>"
```

[Full tfvars file example](examples/enterprise_external_redis.tfvars)

### Label Studio Enterprise with external Redis with SSL

Deploy a Label Studio Enterprise with external Redis with SSL(e.g. already provisioned)..

```hcl
redis_type = "external"
redis_host = "rediss://<REPLACE_ME>:<REPLACE_ME>/1"
redis_password = "<SECRET>"
redis_ssl_mode = "required"
redis_tls_key_file = "<REPLACE_ME>/redis.key"
redis_tls_crt_file = "<REPLACE_ME>/redis.crt"
redis_ca_crt_file = "<REPLACE_ME>/redisCA.crt"
```

[Full tfvars file example](examples/enterprise_external_redis_ssl.tfvars)

## Usage

### Make a copy of an example
To start usage an example of a Terraform configuration and adjust it for your own use, you will need to follow these steps:
1. Find an example of a Terraform configuration that is similar to the infrastructure you want to create.
2. Copy the example configuration and save it to a file with a `.tf` extension. For example, you might save the configuration to a file named `example.tf`.
3. Open the file in a text editor and review the configuration. Look for any values that need to be adjusted to match your desired infrastructure. For example, you might need to change the name of a resource, the size of a virtual machines, or the region where the resources will be created.
4. Change the required environment name, name and [AWS regions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html): 
```hcl
environment = "demo"
name        = "ls"
region      = "eu-north-1"
```

### Deployment
1. Initialize and configure backend:
```shell
make init "provider=aws" "var_file=$(pwd)/terraform/aws/examples/opensource.tfvars"
```
2. Plan all AWS resources:
```shell
make plan "provider=aws" "var_file=$(pwd)/terraform/aws/examples/opensource.tfvars"
```
3. Create or update Terraform resources:
```shell
make apply "provider=aws" "var_file=$(pwd)/terraform/aws/examples/opensource.tfvars"
```
4. Check an output for available endpoints.
5. Destroy all Terraform resources:
```shell
make destroy "provider=aws" "var_file=$(pwd)/terraform/aws/examples/opensource.tfvars"
```

## TFsec
In order to ensure that our infrastructure is secure and compliant with best practices we have a CI integration with [TFsec](https://aquasecurity.github.io/tfsec/).

These checks are designed to help us identify potential security vulnerabilities in our Terraform configuration, and skipping them could leave our infrastructure at risk.

However, we have suppressed few checks as it's impossible to satisfy them and/or they are not related to our demo-cases.
More info can be found in [TFSEC.md](TFSEC.md)