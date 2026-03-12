output "ecr_repository_url" {
  description = "ECR repository URL to push images from GitHub Actions"
  value       = aws_ecr_repository.app.repository_url
}

output "apprunner_service_url" {
  description = "Default HTTPS endpoint for the Next.js app"
  value       = "https://${aws_apprunner_service.app.service_url}"
}

output "apprunner_service_arn" {
  description = "App Runner service ARN"
  value       = aws_apprunner_service.app.arn
}
