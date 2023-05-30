### __USING TERRAFORM IAC TOOL TO AUTOMATE AWS CLOUD SOLUTION FOR 2 COMPANY WEBSITES (INTRODUCING ANSIBLE & PACKER) - PART 4__.

In [Project-18](https://github.com/dybran/Project-18/blob/main/Project-18.md), we migrated our __terraform.tfstate__ file to __S3__ bucket for easy collaboration amongst DevOps team mates in an organisation.

We will be introducing [__Terraform Cloud__](https://developer.hashicorp.com/terraform/cloud-docs). Terraform Cloud is an application that helps teams use Terraform together. It manages Terraform runs in a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations and more.
Teams can  connect Terraform to version control, share variables, run Terraform in a stable remote environment, and securely store remote state.

Terraform Cloud executes Terraform commands on disposable virtual machines, this remote execution is also called [remote operations.](https://developer.hashicorp.com/terraform/cloud-docs/run/remote-operations).

### __Migrate the .tf codes to Terraform Cloud__.

