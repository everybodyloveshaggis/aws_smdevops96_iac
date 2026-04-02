variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "smdevops96-nextjs-cvsite"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "prod"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "smdevops96-nextjs"
}

variable "ecr_images_to_keep" {
  description = "Number of most recent images to retain in ECR"
  type        = number
  default     = 15
}

variable "image_tag" {
  description = "Image tag App Runner should deploy"
  type        = string
  default     = "latest"
}

variable "container_port" {
  description = "Port exposed by the Next.js container"
  type        = number
  default     = 3000
}

variable "instance_cpu" {
  description = "App Runner CPU size"
  type        = string
  default     = "0.25 vCPU"
}

variable "instance_memory" {
  description = "App Runner memory size"
  type        = string
  default     = "0.5 GB"
}

variable "min_size" {
  description = "Minimum number of App Runner instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of App Runner instances"
  type        = number
  default     = 2
}

variable "max_concurrency" {
  description = "Max requests per instance before scale-out"
  type        = number
  default     = 100
}

variable "health_check_path" {
  description = "Path used for HTTP health checks"
  type        = string
  default     = "/"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}