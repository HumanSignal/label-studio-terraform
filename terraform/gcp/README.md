# Label Studio GCP GKE Terraform Module

The Label Studio AWS EKS Terraform module is a tool for deploying LabelStudio on Amazon Web Services Elastic Kubernetes Service (AWS EKS). This module allows users to easily deploy and manage LabelStudio in a scalable, highly available manner using the AWS cloud and Kubernetes.

This document will provide an overview of the deployment process and the prerequisites for using the module. It will also cover the configuration options and provide step-by-step instructions for deploying LabelStudio on AWS EKS using the Terraform module. Finally, it will provide tips for testing and validating the deployment, as well as next steps for updating and modifying the deployment.



## What is Elastic Kubernetes Service(EKS)?
[Amazon Elastic Kubernetes Service](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) is a managed Kubernetes service on AWS, it gives user flexibility to run and scale Kubernetes applications in the AWS cloud.

## Prerequisites for this module

| NAME                                                         | Version | 
|--------------------------------------------------------------|---------|
| [Common prerequisites](../../README.md#Common-prerequisites) |         | 
| gcloud                                                       | 413.0.0 |

### How to install gcloud

Consult the [Google Cloud documentation](https://cloud.google.com/sdk/docs/install) for specific instructions for your system.

## GCP account
You should have an AWS account and appropriate permissions to create and manage the resources required for the deployment. This includes the ability to create and manage EC2 instances, S3 buckets, and other AWS services.
