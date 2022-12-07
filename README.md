# Label Studio Terraform
This repo contains a Terraform modules for provisioning Label Studio/Label Studio Enterprise on Amazon Web Services(AWS).

## Resource Naming Conventions
* Naming Conventions: All the resources will be created with the prefix of `environment`-`project_name`.
    - eg: environment="dev" and Project_name="ls"
            resource_name "dev-ls-gke-cluster"

* Naming Limitation: Every cloud provider have limitations on the resource names, they will only allow resource names up to some characters long.
    - eg: If we pass `environment`=**production** the `project_name`=**lse-terraform-project-resources-for-multiple-cloud-providers** 
    your resource will create as resource_name =**production-lse-terraform-project-resources-for-multiple-cloud-providers-gke-cluster**
    
    * In the above example the resource name exceeds more than 63 characters long. It is an invalid resource name, these will error out when you run `terraform plan` or `terraform validate` commands. These limitations are hard limitations which can not be changed by your cloud provider.
    make sure you followed naming standards while creating your resources. **It is a good practice maintain limits on length of resource names**.

## How to use Makefile 
* Terraform scripts stored in different folders. You have to specify your cloud provider to create resources.
* List of available providers: "aws"

| Command                               | Description                                  |
|---------------------------------------|----------------------------------------------|
| `make help`                           | List all the available options to use        |
| `make init "provider=<REPLACEME>"`    | Initialize and configure Terraform backend   |
| `make plan "provider=<REPLACEME>"`    | Plan all Terraform resources                 |
| `make apply "provider=<REPLACEME>"`   | Create or update Terraform resources         |
| `make destroy "provider=<REPLACEME>"` | Destroy all Terraform resources              |
| `make lint`                           | Check syntax of all scripts                  |
| `make docs`                           | Generate documentation for terraform modules |


## Provider AWS

* Set up environment on your machine before running the make commands. use the following links to setup your machine.
    * [Prerequisites](./aws#Prerequisites)
    * [Tools](./aws#Tools)
    * [AWS-IAM-authenticator](./aws#AWS-IAM-authenticator)
    * [Configure-AWSCLI](./aws#Configure-AWSCLI)

* How to create AWS EKS cluster resources by using the make command
Before using the make commands export the following terraform environment variables(TFVARS) for terraform to create the resources. 

```bash
# Terraform environment name, eg. "dev"
export TF_VAR_environment=dev

# Project name, eg. "ls"
export TF_VAR_name=ls

# AWS region name, eg. "us-east-1" 
export TF_VAR_region=us-east-2
```

```bash
#To list out the available options to use.
make help
```
### Important: Before running the following command, we need to Export the environment variables as show above.

```bash
# Initialize and configure Backend.
make init "provider=aws"
```
```bash
# Plan all GCP resources.
make plan "provider=aws"
```
### This command will all the necessary infrastructure and deploy Label Studio/Label Studio Enterprise on the AWS EKS cluster.
```bash
# Create or update AWS resources
# This command takes some time to execute. 
make apply "provider=aws"
```
```bash
# Destroy all AWS resources created 

make destroy "provider=aws"
```


## Troubleshooting

* **The create script fails with a `Permission denied` when running Terraform** - The credentials that Terraform is using do not provide the necessary permissions to create resources in the selected projects. Ensure that the account listed in `gcloud config list` has necessary permissions to create resources. If it does, regenerate the application default credentials using `gcloud auth application-default login`.

* **Terraform timeouts** - Sometimes resources may take longer than usual to create and Terraform will timeout. The solution is to just run `make create` again. Terraform should pick up where it left off.

* **Terraform state lock** - Sometime if two are more people working on the same Terraform state file a lock will be placed on your remote Terraform state file, to unlock the state run the following command `terraform force-unlock <LOCK_ID>`.

* **Terraform Incomplete resource deletion** - If you created some resources manually on the cloud bash and attach those resources to the resources created by the Terraform, `terraform destroy` or `make destroy` commands will fail. To resolve those errors you will have to login into the cloud bash, delete those resource manually and run `make destroy` or `terraform destory`.
