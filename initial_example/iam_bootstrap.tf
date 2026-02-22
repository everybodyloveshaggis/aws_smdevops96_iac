# iam-bootstrap.tf

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "tfc_ecs" {
  statement {
    sid    = "ECSWrite"
    effect = "Allow"
    actions = [
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:ListClusters",
      "ecs:TagResource",
      "ecs:UntagResource",

      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeTaskDefinition",
      "ecs:ListTaskDefinitions",

      "ecs:CreateService",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:DescribeServices",
      "ecs:ListServices"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "PassRoleToEcsTasks"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Attach as an inline policy to the IAM user "Terraform"
resource "aws_iam_user_policy" "tfc_ecs_inline" {
  name = "TerraformECSAccess"
  user = "Terraform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECSProvisioning"
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeClusters",
          "ecs:ListClusters",
          "ecs:TagResource",
          "ecs:UntagResource",

          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTaskDefinitions",

          "ecs:CreateService",
          "ecs:UpdateService",
          "ecs:DeleteService",
          "ecs:DescribeServices",
          "ecs:ListServices"
        ]
        Resource = "*"
      },
      {
        Sid      = "PassExecutionRoleToEcsTasks"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = aws_iam_role.ecsTaskExecutionRole.arn
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "ecs-tasks.amazonaws.com"
          }
        }
      }
    ]
  })
}