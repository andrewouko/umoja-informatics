// Create a postgres RDS instance (free tier)
// Use the rds security group and subnet group
resource "aws_db_instance" "rds_instance" {
    identifier = "rds-instance-${terraform.workspace}"
    engine = "postgres"
    instance_class = "db.t3.micro" // Free tier
    allocated_storage = 10
    username = var.db_username
    password = var.db_password
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    skip_final_snapshot = true  
    // Make the RDS instance publicly accessible only in the dev environment
    publicly_accessible = contains(["dev"], terraform.workspace) ? true : false
}

// Output the RDS endpoint so that we can connect to it
output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}