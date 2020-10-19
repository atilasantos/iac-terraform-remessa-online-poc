terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "atilaPocs"

    workspaces {
      name = "iac-terraform-remessa-online-poc"
    }
  }
}
