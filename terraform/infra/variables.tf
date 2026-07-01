variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "prod"
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL for the resume container image"
  default     = "210108548781.dkr.ecr.us-east-1.amazonaws.com/resume"
}

variable "resume_container_url" {
  type        = string
  description = "URL for API Gateway to proxy resume requests to (temporary until auto-update is wired)"
  default     = "http://127.0.0.1:3000"
}
