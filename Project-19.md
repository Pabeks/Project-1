### __USING TERRAFORM IAC TOOL TO AUTOMATE AWS CLOUD SOLUTION FOR 2 COMPANY WEBSITES (INTRODUCING TERRAFORM CLOUD, ANSIBLE & PACKER) - CONTINUATION__.

In [Project-18](https://github.com/dybran/Project-18/blob/main/Project-18.md), we migrated our __terraform.tfstate__ file to __S3__ bucket for easy collaboration amongst DevOps team mates in an organisation. We will be introducing [__Terraform Cloud__](https://developer.hashicorp.com/terraform/cloud-docs) to further automate the process.

__BENEFITS:__

[__Terraform Cloud__](https://developer.hashicorp.com/terraform/cloud-docs) is an application that helps teams use Terraform together. It manages Terraform runs in a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations and more.
Teams can  connect Terraform to version control, share variables, run Terraform in a stable remote environment, and securely store remote state.

Terraform Cloud executes Terraform commands on disposable virtual machines, this remote execution is also called [remote operations.](https://developer.hashicorp.com/terraform/cloud-docs/run/remote-operations).

Instead of running the Terraform codes in [Project-18](https://github.com/dybran/Project-18/blob/main/Project-18.md) from a command line, rather it is being executed from [__Terraform Cloud__](https://developer.hashicorp.com/terraform/cloud-docs) console. The __AMI__ is built with __PACKER__ while __ANSIBLE__ is used to configure the infrastructure after its been provisioned with the Terraform script.

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

![](./images/aim.PNG)

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

![](./images/pln-ap.PNG)

Then confirm and apply

![](./images/plnz.PNG)

![](./images/res.PNG)

We can see that the instances in the target groups are __unhealthy__. This is because we have not configured the instances.

![](./images/tgt-u.PNG)
![](./images/tgt-u2.PNG)
![](./images/tgt-u3.PNG)

If we try to configure the instances using Ansible, we will run into a lot of errors. To fix this, we go to the terraform code and comment out the __listeners__ in the __alb.tf__

![](./images/liste.PNG)

Also comment out the __auto scaling attachment__ in the __asg-bastion-nginx.tf__ and __asg-tooling-wordpress.tf__.

![](./images/awt.PNG)

Push the code to github and run the plan. We can see that the changes will be effected when we run apply.

![](./images/desr.PNG)

Apply

![](./images/asss.PNG)

If we check the target group from the console, we will find out that there are no target registered to the groups.

![](./images/not.PNG)

And there are no listeners in the load balancer.

![](./images/li.PNG)

To configure the infrastructure using Ansible, we will need to ssh into the bastion instance. Clck [here](https://www.youtube.com/watch?v=lKXMyln_5q4).

Then clone the Ansible directory in the github.

![](./images/wer.PNG)

Ansible will need to connect to AWS to pick the IP address for the dynamic inventory. We need to run the command

`$ aws configure`

and add the __access key__ and __secret key__ to the bastion instance.

![](./images/12345.PNG)

Then `$ cd /home/ec2-user/Project-19/narbyd-project/Ansible`

Install the __python3-botocore__ and __boto3__

`$ sudo dnf install python3-devel`
 
`$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py`
 
`$ sudo python3.11 get-pip.py`

`$ pip install botocore boto3`

Run the command

`$ ansible-inventory -i inventory/aws_ec2.yml --graph` to make sure that ansible can connect to the ip addresses

![](./images/graph.PNG)

Next, we will update the Ansible with the: 

RDS endpoints for wordpress and tooling, Database name, password and username for wordpress and tooling.
  
![](./images/rds.PNG)
![](./images/dbt.PNG)

Access point ID for wordpress and tooling respectively.
 ![](./images/acc1.PNG)
 ![](./images/acc2.PNG)
 ![](./images/tooling.PNG)

Internal Load balancer DNS for Nginx reverse proxy
  
![](./images/int-lb.PNG)

We can then run the command

`$ ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml`

![](./images/play.PNG)
![](./images/play2.PNG)


We then go to the __terraform__ script and uncomment the __auto scaling attachment__ in the __asg-bastion-nginx.tf__ and __asg-tooling-wordpress.tf__ and also the __listeners__ in the __alb.tf__.

Push the updated terrform code to github. Terraform cloud picks up the changes and runs a plan.

![](./images/tpl.PNG)

Click on apply

![](./images/apppp.PNG)


Check if the target groups are __healthy__

![](./images/health-n.PNG)
![](./images/heath-w.PNG)
![](./images/health-t.PNG)

Access the website from the browser



__PROBLEM ENCOUNTERED:__
- nginx target group was __unhealthy__, I remotely logged into the nginx server through the bastion and found out that there was an error in the `/etc/nginx/nginx.conf` file. Fixed the error and restarted the server - `sudo ssytemctl restart nginx`.
- 











