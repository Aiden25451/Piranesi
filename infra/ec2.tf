// ec2.tf

resource "aws_security_group" "resume_sg" {
  name        = "resume-sg"
  description = "Allow HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "resume" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.default_public.id
  vpc_security_group_ids      = [aws_security_group.resume_sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/scripts/resume-ec2-run.sh")

  tags = {
    Name = "resume-ec2"
  }
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_subnet" "default_public" {
  id = data.aws_subnets.default_public.ids[0]
}