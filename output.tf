output "ec2-instance" {
  value = "${aws_instance.nginx-test.public_ip}"
}