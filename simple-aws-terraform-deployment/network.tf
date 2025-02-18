// Define the VPC and its IP range
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  // Resolve domain names to IP addresses in dev
  enable_dns_support = contains(["dev"], terraform.workspace) ? true : false
  // Assign DNS names to the instances in dev
  enable_dns_hostnames = contains(["dev"], terraform.workspace) ? true : false

  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

// Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${terraform.workspace}-igw"
  }
}

// Fetch the availability zones in the region
data "aws_availability_zones" "available" {}

// Create two subnets in the VPC, each in a different availability zone
resource "aws_subnet" "main" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)               // Divide each subnet into /24
  availability_zone = element(data.aws_availability_zones.available.names, count.index) // Assign each subnet to an availability zone
  tags = {
    Name = "${terraform.workspace}-subnet-${count.index}"
  }
}

// Route any outgoing traffic to the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${terraform.workspace}-public-route-table"
  }
}

// Make all the subnets public by associating them with the public route table
// So that they can route all outbound traffic to the internet gateway
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.public.id
}

// Lambda security group to allow access to the RDS instance only from the lambda function
resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg_${terraform.workspace}"
  description = "Security group for lambda function to access RDS instance"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Security group (virtual firewall) for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg_${terraform.workspace}"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  // Incoming traffic rules
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    // For prod only allow access from the lambda function
    security_groups = contains(["prod"], terraform.workspace) ? [aws_security_group.lambda_sg.id] : []
    // For dev allow any IP addresses to connect to the RDS instance (for now due to simplicity)
    cidr_blocks     = contains(["dev"], terraform.workspace) ? ["0.0.0.0/0"] : []
  }

  // Outgoing traffic rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          // Allow any protocol
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic to any IP address
  }
}

# Create a subnet group for the RDS instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group_${terraform.workspace}"
  subnet_ids = aws_subnet.main[*].id
}
