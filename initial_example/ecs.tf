# ------------------------------------------------------------------
# ECS cluster
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
# Task definition for the Next.js container
# ------------------------------------------------------------------
resource "aws_ecs_task_definition" "nextjs" {
  family                   = "nextjs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "512"
  memory = "1024"

  # execution role must allow pulling from ECR and writing logs
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name  = "nextjs"
      image = "${aws_ecr_repository.cv_site.repository_url}:latest" # or a specific tag

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

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
# Service that runs the task on the cluster
# ------------------------------------------------------------------
resource "aws_ecs_service" "nextjs" {
  name            = "nextjs-service"
  cluster         = aws_ecs_cluster.cv-site-nextjs_cluster.id
  task_definition = aws_ecs_task_definition.nextjs.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  # networking (required for Fargate/awsvpc)
network_configuration {
  subnets          = [aws_subnet.public1.id, aws_subnet.public2.id]
  security_groups  = [aws_security_group.ecs_sg.id]
  assign_public_ip = true
}

  # register with ALB target group
  load_balancer {
    target_group_arn = aws_lb_target_group.nextjs.arn
    container_name   = "nextjs"
    container_port   = 3000
  }

  # Only depend on LB resources you explicitly reference here
  depends_on = [
    aws_lb_listener.http_listener
  ]
}