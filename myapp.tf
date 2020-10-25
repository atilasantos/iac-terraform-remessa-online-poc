# app

data "template_file" "myapp-task-definition-template" {
  template = file("templates/app.json.tpl")
  vars = {
    REPOSITORY_URL = "660116746687.dkr.ecr.us-east-2.amazonaws.com/remessa-repository"
  }
}

resource "aws_ecs_task_definition" "myapp-task-definition" {
  family                = "nginx"
  container_definitions = data.template_file.myapp-task-definition-template.rendered
}

resource "aws_elb" "myapp-elb" {
  name = "myapp-elb"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2 // Will validate three times the healthcheck to make sure it is available to send traffic.
    unhealthy_threshold = 2 // Will validate two times if the instance is not ok so it will stop sending traffic to the checked instance. 
    timeout             = 4
    target              = "HTTP:80/"
    interval            = 20 // Each 20 seconds it'll check the target endpoint and apply the rules based on healthy and unhealthy.
  }

  subnets         = [aws_subnet.main-public-1.id]
  security_groups = [aws_security_group.myapp-elb-securitygroup.id]

  tags = {
    Name = "myapp-elb"
  }
}

resource "aws_ecs_service" "myapp-service" {
  name            = "myapp"
  cluster         = aws_ecs_cluster.example-cluster.id
  task_definition = aws_ecs_task_definition.myapp-task-definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_policy_attachment.ecs-service-attach1]

  load_balancer {
    elb_name       = aws_elb.myapp-elb.name
    container_name = "nginx"
    container_port = 80
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

