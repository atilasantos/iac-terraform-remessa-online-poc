# Deploying a Nginx service with ECS

## Pre-requesites ✔️
- Have an account on [AWS](https://aws.amazon.com/pt/premiumsupport/knowledge-center/create-and-activate-aws-account/ "Creating an aws account").
- While creating your [IAM](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html "How to create IAM user account") don't forget to download the .csv file with the generated key, secret pair, you'll need them in the further steps.
- Install Terraform CLI v0.13.0:
    ```
    wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip ;
    unzip terraform_0.13.0_linux_amd64.zip;
    sudo mv terraform /usr/local/bin
    ```


## Getting started 🚀
- First we need to install the [aws cli](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/install-cliv2.html "Installing aws cli"), try execute ***aws --version*** right after the instalation, something like the snippet below must be displayed:

    ``aws-cli/2.0.56 Python/3.7.3 Linux/5.4.0-51-generic exe/x86_64.ubuntu.18``
- Second we need to [associate our AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html "Configure aws credentials") to our local CLI so terraform would be able to identify what credentials to use while provisioning IAC on aws provider.