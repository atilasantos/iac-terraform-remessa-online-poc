variable "amis" {
    type = "map"

    default = {
        "nginx-ami" = "ami-07a027b7e4a98480b"
    }
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "key_name" {
    default = "rsa_key"

}

variable "my_ip" {
    type = "list"
    default = ["45.232.198.120/32"]
  
}
