#create's subnet
resource "aws_subnet" "app_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.az
  tags = {
    Name = "${var.env}-subnet-1"
  }
}
#create's igp
resource "aws_internet_gateway" "app_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-igw"
  }
}
#attach igp to the default rt of the new vpc
resource "aws_default_route_table" "main-rt" {
    default_route_table_id = var.aws_default_route_table
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.app_igw.id
      }
    tags = {
      Name = "${var.env}-main-rt"
    }
}