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
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 in us-east-1
  instance_type = "t3.micro"

  user_data = file("${path.module}/scripts/resume-ec2-run.sh")

  vpc_security_group_ids = [aws_security_group.resume_sg.id]
  subnet_id              = data.aws_subnet.default_public.id

  associate_public_ip_address = true

  tags = {
    Name = "resume-ec2"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default_public" {
  vpc_id            = data.aws_vpc.default.id
  default_for_az    = true
}