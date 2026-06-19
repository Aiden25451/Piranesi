resource "aws_apigatewayv2_api" "piranesi" {
  name          = "PiranesiGateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.piranesi.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.piranesi.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.piranesi.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_integration" "resume" {
  api_id                 = aws_apigatewayv2_api.piranesi.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "http://${aws_instance.resume.public_ip}:3000"
}

resource "aws_apigatewayv2_route" "resume" {
  api_id    = aws_apigatewayv2_api.piranesi.id
  route_key = "ANY /resume/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.resume.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.piranesi.id
  name        = "$default"
  auto_deploy = true
}
