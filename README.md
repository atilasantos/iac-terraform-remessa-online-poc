# Deploying a Nginx service with ECS

## Overview 
This repository allows you to provision a cluster (ECS on AWS) with:
- Nginx image
- Elastic load balancer
- Auto scaling group 

Obs: This README.md file was written focused to Linux users, may other OS systems will be covered in the future 😅

## Pre-requesites ✔️
- Have an account on [AWS](https://aws.amazon.com/pt/premiumsupport/knowledge-center/create-and-activate-aws-account/ "Creating an aws account").
- While creating your [IAM](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html "How to create IAM user account"), don't forget to download the .csv file with the generated key/secret pair, you'll need them in the further steps.
- Install Terraform CLI v0.13.0:
    ```
    wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip ;
    unzip terraform_0.13.0_linux_amd64.zip;
    sudo mv terraform /usr/local/bin
    ```
- Create a S3 Bucket (fix the name if necessary in [backend.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/backend.tf))
- Create an ECR registry and push the nginx image to that as the [following](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html) article.

## Getting started 🚀
1. Install the [aws cli](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/install-cliv2.html "Installing aws cli"), try execute ***aws --version*** right after the instalation, something like the snippet below must be displayed:

    ``aws-cli/2.0.56 Python/3.7.3 Linux/5.4.0-51-generic exe/x86_64.ubuntu.18``
2. [Associate AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html "Configure aws credentials") to our local aws CLI so terraform would be able to identify what credentials to use while provisioning IAC on aws provider.

3. In order to set the right key-pair to get logged into the EC2 instance, clone this repository and inside the root folder, execute:
```shell
ssh-keygen -f mykey -N '' -q;
key=`cat mykey.pub`;
sed -i "6d" mainvars.tf;
sed -i "6i \ " mainvars.tf;
sed -i "6i \ \ default = \"$key\"" mainvars.tf;
```

## Terraform files
This repository is responsible for provisioning the aimed infrastructure, however it uses a modularized structure provided by another [repository](https://github.com/atilasantos/iac-terraform-modules-remessa-online-poc.git) also written by me, in this section i'll go over the files which belongs to this repo.
-  [backend.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/backend.tf): Define a remote versioned backend using S3 bucket service. The S3 bucket must be created before initializing terraform.
- [main.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/main.tf): Define how to create the cluster by providing the required variables from all the necessary modules.
- [mainvars.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/mainvars.tf): Define 'global' variables used by terraform.
- [output.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/output.tf): Define which information will be displayed when the apply is successfully executed. In our example, will display the elb_dns_name so we can check wether nginx is up or not.
- [provider.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/provider.tf): Define AWS as provisioner and us-east-2 as region to provision our infrastructure.

## Other files
- [Jenkinsfile](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/Jenkinsfile): Define the stages to be executed when a job is started in Jenkins.
- [validate_availability.sh](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/validate_availability.sh): Script to check wheter nginx is up or not, once it is, it'll open a Google Chrome tab with the needed URL to display the service.

## Provisioning
Follow the steps bellow to provision the infrastructure without hadaches:
1. Inside the repository root folder, execute:
```shell
terraform init
```
2. Once the modules, backend and plugins were initialized, execute:
```shell
terraform plan
```
3. Check if all the necessary resources are planned to be provisioned and then execute:
```shell
terraform apply -auto-approve
```
## Validating the ELB_DNS_NAME
Once the apply is executed, and a ELB_DNS_NAME was provided, execute:
```shell
./validate_availability.sh ${ELB_DNS_NAME}

Where ELB_DNS_NAME is the name provided as output in the apply.
```
The script will keep running until nginx instance is up, once this condition is reached, the script will open a Chrome tab with the nginx front-end.
Bellow the output example:
```shell
 ELB not resolved.. 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   621  100   621    0     0   1621      0 --:--:-- --:--:-- --:--:--  1621
 ELB finally resolved! 
Opening in existing browser session.
```
## Destroying the provisioned infrastructure
Once the validation is ok, execute:
```shell
terraform destroy -auto-approve
```

## Any questions?
Feel free to contact me via atila.romao@hotmail.com