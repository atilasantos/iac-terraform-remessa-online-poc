module "iam" {
  source = "github.com/atilasantos/iac-terraform-modules-remessa-online-poc/modules/iam"
}
module "vpc" {
  source = "github.com/atilasantos/iac-terraform-modules-remessa-online-poc/modules/vpc"
}
module "ecs_task" {
  source = "github.com/atilasantos/iac-terraform-modules-remessa-online-poc/modules/ecs-task"
}
module "ecs_cluster" {
  source = "github.com/atilasantos/iac-terraform-modules-remessa-online-poc/modules/ecs-cluster"

  IAM_INSTANCE_PROFILE_ID = "${module.iam.aws_iam_instance_profile-ecs-ec2-role-id}"
  ECS_SECURITY_GROUP_ID   = module.vpc.nginx-ecs-securitygroup-id
  KEY_PAIR_NAME           = "${aws_key_pair.mykey.key_name}"
  VZI_SUBNET_ID           = "${module.vpc.nginx-public-subnet-id}"
}

module "ecs_service" {
  source = "github.com/atilasantos/iac-terraform-modules-remessa-online-poc/modules/ecs-service"

  CLUSTER_ID                           = "${module.ecs_cluster.nginx-cluster}"
  TASK_DEFINITION_ARN                  = "${module.ecs_task.nginx-task-definitio-arn}"
  IAM_ROLE_ECS_SERVICE_ROLE_ARN        = "${module.iam.aws_iam_role-ecs-service-role-arn}"
  IAM_POLICY_ATTACH_ECS_SERVICE_ATTACH = [module.iam.aws_iam_policy-attach-ecs-service-attach]
  ELB_NAME                             = "${module.elb.elb_name}"

}

module "elb" {
  source = "github.com/atilasantos/iac-terraform-modules-remessa-online-poc/modules/elb"

  PUBLIC_SUBNET_ID      = "${module.vpc.nginx-public-subnet-id}"
  ELB_SECURITY_GROUP_ID = "${module.vpc.nginx-elb-securitygroup-id}"
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = "${var.KEY_VALUE}"
  lifecycle {
    ignore_changes = [public_key]
  }
}