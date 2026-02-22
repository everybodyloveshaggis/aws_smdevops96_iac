# ------------------------------------------------------------------
# task definition for cluster
# ------------------------------------------------------------------

resource "aws_ecs_cluster" "cv-site-nextjs_cluster" {
  name = "cv-site-nextjs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

    tags = {
        Environment = "production"
        Project     = "cv-site-nextjs"
    }
}



# ------------------------------------------------------------------
# task definition for the Next.js container
# ------------------------------------------------------------------
resource "aws_ecs_task_definition" "nextjs" {
  family                   = "nextjs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                      = "512"
  memory                   = "1024"

  # execution role must allow pulling from ECR and writing logs
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name  = "nextjs"
      image = "${aws_ecr_repository.cv-site-nextjs.repository_url}:latest"  # or a specific tag

      portMappings = [{
        containerPort = 3000
        protocol      = "tcp"
      }]

      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/nextjs"
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ------------------------------------------------------------------
# service that runs the task on the cluster
# ------------------------------------------------------------------
resource "aws_ecs_service" "nextjs" {
  name            = "nextjs-service"
  cluster         = aws_ecs_cluster.cv-site-nextjs_cluster.id
  task_definition = aws_ecs_task_definition.nextjs.arn
  desired_count   = 2
  launch_type     = "FARGATE"             # or "EC2" if using EC2 instances

  # networking (required for Fargate/awsvpc)
  network_configuration {
    subnets          = aws_subnet.app_subnet.*.id     # or public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  # optional – register with an ALB target group
  load_balancer {
    target_group_arn = aws_lb_target_group.nextjs.arn
    container_name   = "nextjs"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_target_group.nextjs,             # if you use a LB
    aws_iam_role_policy.ecsTaskExecution   # ensure roles/policies exist
  ]
}