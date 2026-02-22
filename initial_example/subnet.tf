# subnets.tf
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = { Name = "public-1" }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = { Name = "public-2" }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "${var.aws_region}a"

  tags = { Name = "private-a" }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "${var.aws_region}b"

  tags = { Name = "private-b" }
}

resource "aws_subnet" "app_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, 10 + count.index) # 10.0.10.0/24, 10.0.11.0/24
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = { Name = "app-${count.index}" }
}