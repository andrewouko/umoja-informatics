// Role for all lambda functions to assume when executing
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

// Create a policy for full S3 access to the static bucket to only the simple lambda
resource "aws_iam_policy" "full_s3_access_policy" {
  name        = "full_s3_access_policy_${terraform.workspace}"
  description = "Policy for full S3 access to static bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.simple_static_bucket.arn}",
          "${aws_s3_bucket.simple_static_bucket.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = [
              aws_lambda_function.simple_lambda.arn
            ]
          }
        }
      }
    ]
  })
}

// Create a policy for S3 read access to the static bucket to only the simple lambda
resource "aws_iam_policy" "s3_read_access_policy" {
  name        = "s3_read_access_policy_${terraform.workspace}"
  description = "Policy for S3 read access to static bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "${aws_s3_bucket.simple_static_bucket.arn}",
          "${aws_s3_bucket.simple_static_bucket.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = [
              aws_lambda_function.simple_lambda.arn
            ]
          }
        }
      }
    ]
  })
}


// Attach basic lambda execution policy to the role
// Allows the lambda to write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach the full S3 access policy to the lambda role
// For now as the criteria is to keep it simple, we are granting full access to the lambda
// We can always limit as required using the read access policy
resource "aws_iam_role_policy_attachment" "full_s3_access_policy_attachment" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.full_s3_access_policy.arn
}

