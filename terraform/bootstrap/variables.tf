variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "prod"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository in org/repo format"
  default     = "aasprakis/Piranesi"
}
