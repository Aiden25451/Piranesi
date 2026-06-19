#!/bin/bash
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin 210108548781.dkr.ecr.us-east-1.amazonaws.com

docker pull 210108548781.dkr.ecr.us-east-1.amazonaws.com/resume:latest

docker run -d \
  --name resume \
  -p 3000:3000 \
  210108548781.dkr.ecr.us-east-1.amazonaws.com/resume:latest
