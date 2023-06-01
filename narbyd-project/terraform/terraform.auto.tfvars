region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

# enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "dev"

ami-web = "ami-08e23dd3eabdf7456"

ami-bastion = "ami-02767f1ad3ce42ad4"

ami-nginx = "ami-0df552f7c96a35ad6"

ami-sonar = "ami-0e91d6f4b75361cfb"

keypair = "dybran-ec2"

master-password = "Sa4la2xa###"

master-username = "narbyd"

account_no = "939895954199"

tags = {
  Owner-Email     = "onwuasoanyasc@gmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "939895954199"
}
