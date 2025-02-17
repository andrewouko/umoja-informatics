/**
 * This file is used to create an HTTP API Gateway to expose the lambda function
 * 
 * @module root
 */

// Use the v2 version of the API Gateway to create a HTTP API
 resource "aws_apigatewayv2_api" "simple_http_api_gateway" {
  name          = "simple_http_api_gateway_${terraform.workspace}"
  protocol_type = "HTTP"
}

// Integration between the HTTP API Gateway and the lambda function
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.simple_http_api_gateway.id
  integration_type = "AWS_PROXY" // allow lambda to handle entire request and response
  integration_uri = aws_lambda_function.simple_lambda.invoke_arn
  integration_method = "POST"
}

// A post route for the HTTP API Gateway
resource "aws_apigatewayv2_route" "hello" {
  api_id = aws_apigatewayv2_api.simple_http_api_gateway.id
  route_key = "POST /hello"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

// Make the API Gateway auto deploy and use the stage from terraform workspace
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.simple_http_api_gateway.id
  name = terraform.workspace
  auto_deploy = true
}

// Output the API Gateway URL so that we can use it to test the API
output "api_gateway_url" {
  value = aws_apigatewayv2_api.simple_http_api_gateway.api_endpoint
}