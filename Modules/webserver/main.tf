#configuring default security group
resource "aws_default_security_group" "default-sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip] 
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "${var.env}-sg"
    }
}

#fetching previously created key-pair
data "aws_key_pair" "ssh_key_pair" {
  key_name = "ssh"
}

#fetching latest ami id 
data "aws_ami" "amzn_linux_latest" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

#creating instance 
resource "aws_instance" "app_server" {
  ami = data.aws_ami.amzn_linux_latest.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  availability_zone = var.az
  vpc_security_group_ids = [ var.default_sg_id ]
  associate_public_ip_address = true
  key_name = data.aws_key_pair.ssh_key_pair.key_name
  user_data = var.user_data
  tags = {
    Name = "${var.env}-server"
  }
}