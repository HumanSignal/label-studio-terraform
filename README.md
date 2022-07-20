## Label Studio Terraform
The LabelStudio terraform module allows users to easily deploy a fully-featured instance of [Label Studio/Label Studio Enterprise](https://labelstud.io/) on multiple cloud providers, including AWS, Google Cloud(support in 2023) and Azure(support in late 2023).

With [Label Studio/Label Studio Enterprise](https://labelstud.io/), users can create custom labeling interfaces, manage the labeling process, and export labeled data for use in machine learning and other applications.

## Introduction
The module provides a set of [pre-defined configuration examples](terraform/aws/examples) that can be easily customized to meet the needs of your project. It includes options for specifying the cloud provider, the region to deploy the Label Studio/Label Studio Enterprise instance, and various other parameters such as the number of replicas and 3rd party integrations.

Using the module, you can quickly set up a Label Studio/Label Studio Enterprise instance that is ready to use, without the need to manually configure and deploy the various components of the system. Whether you are a data scientist, machine learning engineer, or just someone who needs to create high-quality labeled data, the LabelStudio terraform module can help you get up and running quickly and easily on your preferred cloud provider.

## Common prerequisites

| NAME        | Version | 
|-------------|---------|
| MacOS/Linux | any     |
| Terraform   | 1.3.6   |
| Helm        | 3.10.x  |
| kubectl     | 1.24.x  |

### How to install Terraform

Consult the [Terraform documentation](https://developer.hashicorp.com/terraform/downloads) for specific instructions for your system.

### How to install Helm

Consult the [Helm documentation](https://helm.sh/docs/intro/install/) for specific instructions for your system.

### How to install kubectl

Follow the step from official Kubernetes documentation:
- [Install kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Install kubectl on macOS](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)


## How to use Makefile 
* Terraform scripts stored in different folders. You have to specify your cloud provider to create resources.
* List of supported providers: `aws`.

| Command                                                         | Description                                  |
|-----------------------------------------------------------------|----------------------------------------------|
| `make help`                                                     | List all the available options to use        |
| `make init "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>"`    | Initialize and configure Terraform backend   |
| `make plan "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>"`    | Plan all Terraform resources                 |
| `make apply "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>"`   | Create or update Terraform resources         |
| `make destroy "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>"` | Destroy all Terraform resources              |
| `make lint`                                                     | Check syntax of all scripts                  |
| `make docs`                                                     | Generate documentation for terraform modules |


## Cloud Providers

### Provider AWS

Link to [AWS Provider Documentation](./terraform/aws/README.md)

## Seeking help

If you run into an issue, bug or have a question, please reach out to the Label Studio
community via [Label Studio Slack Community](https://slack.labelstudio.heartex.com/).
