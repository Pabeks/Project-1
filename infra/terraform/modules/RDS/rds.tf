# This section will create the subnet group for the RDS  instance using the private subnet
# create DB subnet group from the private subnets
resource "aws_db_subnet_group" "paje-rds" {
  name       = "paje-rds"
  subnet_ids = var.private_subnets

  tags = merge(
    var.tags,
    {
      Name = "paje-database"
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "paje-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  # name                   = "pajedb"
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.paje-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db-sg
  multi_az               = "true"
}
