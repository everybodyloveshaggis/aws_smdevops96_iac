# variables.tf
variable "public_key" {
  type        = string
  description = "SSH public key material (e.g. for an EC2 key pair) if used."
}

variable "ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH (e.g. 203.0.113.10/32)."
}

variable "aws_region" {
  description = "AWS region prefix used to construct availability‑zone names, e.g. us‑west‑2"
  type        = string
  default     = "eu-west-2"
}