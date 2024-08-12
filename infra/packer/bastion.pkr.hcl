variable "region" {
  type    = string
  default = "us-east-1"
}


variable "ssh_private_key_file" {
  default = "/Users/paulabekah/Downloads/packer.pem"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "paje-bastion" {
  ami_name      = "paje-bastion-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "RHEL-9.4.0_HVM-20240605-x86_64-82-Hourly2-GP3"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
  ssh_interface = "public_ip"
  ssh_keypair_name = "packer"
  ssh_private_key_file = var.ssh_private_key_file
  ssh_timeout = "30m"
  associate_public_ip_address = true
  tag {
    key   = "Name"
    value = "paje-bastion"
  }
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.paje-bastion"]

  provisioner "shell" {
    script = "bastion.sh"
  }
}