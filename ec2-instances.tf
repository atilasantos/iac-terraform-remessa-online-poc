provider "aws" {
    version = "~> 2.0"
    region = "us-east-1"
  
}

resource "aws_instance" "nginx-test" {
    count = 2
    ami = "${var.amis["nginx-ami"]}"
    key_name = "rsa_key"
    instance_type = "${var.instance_type}"
    tags = {
        Name = "nginx-${count.index}"
    }

    vpc_security_group_ids = ["${aws_security_group.ssh-http-us-east-1.id}"]

}

