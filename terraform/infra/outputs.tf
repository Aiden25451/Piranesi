output "api_gateway_url" {
  description = "Base URL of the API Gateway"
  value       = aws_apigatewayv2_api.gateway.api_endpoint
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.piranesi.function_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name for the resume app"
  value       = aws_ecs_cluster.resume.name
}

output "ecs_service_name" {
  description = "ECS service name for the resume app"
  value       = aws_ecs_service.resume.name
}
