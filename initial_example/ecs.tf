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

resource "aws_ecs_task_definition" "nextjs" {
  family                   = "nextjs"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "nextjs",
    "image": "${aws_ecr_repository.cv_site.repository_url}:latest",
    "portMappings": [{ "containerPort": 3000, "hostPort": 3000 }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/nextjs",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "nextjs" {
  name            = "nextjs"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nextjs.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nextjs_tg.arn
    container_name   = "nextjs"
    container_port   = 3000
  }
}