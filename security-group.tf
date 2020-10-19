resource "aws_security_group" "ssh-http-us-east-2" {
  name        = "acesso-ssh-http"
  description = "acesso-ssh-http"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.my_ip}"
  }

  ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = "${var.my_ip}"
  }
  
  tags = {
    Name = "ssh/http"
  }
}
