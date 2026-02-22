# variables.tf
variable "public_key" {
  type        = string
  description = "SSH public key material (e.g. for an EC2 key pair) if used."
}

variable "ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH (e.g. 203.0.113.10/32)."
}