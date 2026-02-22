variable "ssh_cidr" {
  description = "CIDR block that is allowed to SSH to the instances"
  type        = string
  # you can supply a default or leave it blank and pass it via -var/TF_VAR
  default     = "0.0.0.0/0"
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "Allow inbound HTTP and SSH"
  vpc_id     = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}