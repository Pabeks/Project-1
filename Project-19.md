### __USING TERRAFORM IAC TOOL TO AUTOMATE AWS CLOUD SOLUTION FOR 2 COMPANY WEBSITES (INTRODUCING TERRAFORM CLOUD, ANSIBLE & PACKER) - CONTINUATION__.

In [Project-18](https://github.com/dybran/Project-18/blob/main/Project-18.md), we migrated our __terraform.tfstate__ file to __S3__ bucket for easy collaboration amongst DevOps team mates in an organisation.

We will be introducing [__Terraform Cloud__](https://developer.hashicorp.com/terraform/cloud-docs). Terraform Cloud is an application that helps teams use Terraform together. It manages Terraform runs in a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations and more.
Teams can  connect Terraform to version control, share variables, run Terraform in a stable remote environment, and securely store remote state.

Terraform Cloud executes Terraform commands on disposable virtual machines, this remote execution is also called [remote operations.](https://developer.hashicorp.com/terraform/cloud-docs/run/remote-operations).

Instead of running the Terraform codes in __Project-18__ from a command line, rather it is being executed from __TERRAFORM CLOUD__ console. The AMI is built with __PACKER__ while __ANSIBLE__ is used to configure the infrastructure after its been provisioned by Terraform.

__TASKS__

- Build AMIs using Packer
- Update the terraform script with the AMI IDs generated from packer build
- Create terraform cloud and backend
- Run terraform script
- Update Ansible script with values from Terraform output
	- RDS endpoints for wordpress and tooling
	- Database name, password and username for wordpress and tooling
	- Access point ID for wordpress and tooling
	- Internal Load balancer DNS for Nginx reverse proxy
- Run the Ansible script
- Access the website through the browser.


__PREREQUISITE__

- Install __ANSIBLE__
- Install [__PACKER__](https://developer.hashicorp.com/packer/downloads?product_intent=packer).
- Configure [__AWS CLI__](https://www.youtube.com/watch?v=u0JyzUGzvJA).

__Create the AMIs using PACKER__

First we install __PACKER__ through the powershell - run as administrator.

`$ choco install packer -y`

![](./images/choco.PNG)

Go through the documentation to set up the __PACKER__ file. Click [here](https://developer.hashicorp.com/packer/docs/templates/hcl_templates).

__PACKER__ is used in this project to create the AMIs for the launch templates used by the Auto Scaling Group. The code has been modified for PACKER to create the AMIs. The packer creates the instances, provision the instances using the shell scripts and creates the AMIs. It also deletes the instances when the AMIs are created.
The codes can be found [here](https://github.com/dybran/Project-19/tree/main/narbyd-project).

`$ cd narbyd-terraform-cloud\narbyd-project\AMI`

Then build the AMIs.

`$ packer build bastion.pkr.hcl`

![](./images/pkr-b.PNG)
![](./images/pkr-b2.PNG)

`$ packer build nginx.pkr.hcl`

![](./images/pkr-n.PNG)
![](./images/pkr-n2.PNG)

`$ packer build ubuntu.pkr.hcl`

![](./images/pkr-u.PNG)
![](./images/pkr-u2.PNG)

`$ packer build web.pkr.hcl`

![](./images/pkr-w2.PNG)

Next we update the __terraform.auto.vars__ with the AMI IDs

![](./images/tvs.PNG)

### __Migrate the .tf codes to Terraform Cloud__.

We can migrate our codes to __Terraform Cloud__ and manage our __AWS__ infrastructure from the terraform cloud.

Create a new repository in our GitHub __narbyd-terraform-cloud__.

![](./images/nw.PNG)

Push the Terraform codes in the __narbyd-project__  to the repository.

![](./images/np1.PNG)
![](./images/np2.PNG)

Create a Terraform Cloud account

![](./images/ws1.PNG)
![](./images/ws2.PNG)
![](./images/ws3.PNG)
![](./images/ws4.PNG)
![](./images/def.PNG)
![](./images/ws5.PNG)

Make sure to switch on the "__automatic speculative plan__".

__Configure variables__

Terraform Cloud supports two types of variables: environment variables and Terraform variables. Either type can be marked as sensitive, which prevents them from being displayed in the Terraform Cloud web UI and makes them write-only.

Set two environment variables: __AWS_ACCESS_KEY_ID__ and __AWS_SECRET_ACCESS_KEY__.

![](./images/vari.PNG)

We will set the values we used in [Project 16](https://github.com/dybran/Project-16) to congifure the __AWS CLI__. These credentials will be used to privision the AWS infrastructure by Terraform Cloud.

Then change the __terraform.tfvars__ to __terraform.auto.tfvars__ on the codes so terraform can use the variables.

__N/B:__ Whenever we update the code in the __narbyd-terraform-cloud__ on GITHUB, the __terraform-cloud__ creates a plan for it automatically making use of version control.









