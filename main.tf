#provider
provider "aws" {
    region = "us-east-1"
}

#create's_vpc
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env}-app_vpc"
  }
}

#importing_subnet_module
module "app-subnet" {
  source = "./Modules/subnet"
  vpc_id = aws_vpc.app_vpc.id
  subnet_cidr_block = var.subnet_cidr_block
  az = var.az
  env = var.env
  aws_default_route_table = aws_vpc.app_vpc.default_route_table_id
}

#importing_app_server_module
module "app-server" {
  source = "./Modules/webserver"
  vpc_id = aws_vpc.app_vpc.id
  env = var.env
  my_ip = var.my_ip
  instance_type = var.instance_type
  subnet_id = module.app-subnet.subnet.id
  default_sg_id = aws_vpc.app_vpc.default_security_group_id
  az = var.az
  user_data = file(var.user_data)
}