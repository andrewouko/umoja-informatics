/**
 * This file is used to create a lambda function
 * 
 * @module root
 */

 // Create the zip file for the lambda function source code
data "archive_file" "simple_lambda_zip" {
    type = "zip"
    source_dir = "${path.module}/simple_lambda/dist"
    output_path = "${path.module}/simple_lambda.zip"
}

// Simple lambda function with an environment variable to indicate the environment
resource "aws_lambda_function" "simple_lambda" {
  function_name = "simple_lambda_${terraform.workspace}"
  handler = "index.handler"
  runtime = "nodejs20.x"
  role = aws_iam_role.lambda_role.arn
  filename = data.archive_file.simple_lambda_zip.output_path
  source_code_hash = data.archive_file.simple_lambda_zip.output_base64sha256
  environment {
    variables = {
      ENV = terraform.workspace
    }
  }
}