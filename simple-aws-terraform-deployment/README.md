# Simple AWS Terraform Deployment

This project sets up a simple AWS infrastructure using Terraform. It includes an S3 bucket for static file storage, a Lambda function, and an HTTP API Gateway to expose the Lambda function.

## Prerequisites

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- AWS CLI configured with appropriate credentials

```sh
export AWS_ACCESS_KEY_ID=<Your aws access key>
export AWS_SECRET_ACCESS_KEY=<Your aws secret access key>
```

OR

```sh
aws configure
```

## Setup Instructions

### 1. Transpile the lambda source code

Navigate to the project directory and build the lambda code

```sh
cd simple_lambda
npm i
npm run build
```

### 2. Initialize the Terraform Project

Navigate to the project directory and initialize the Terraform project:

```sh
terraform init
```

### 3. Create and Switch Workspaces

Create and switch to the desired workspace (e.g., dev, staging, prod): The workspace can be used to deploy resources to different environments. The terraform code uses workspace property to deploy resources to different environments

```sh
terraform workspace new dev
terraform workspace new prod
```

```sh
terraform workspace list
```

```sh
terraform workspace select dev
```

OR

```sh
terraform workspace select prod
```

### 4. Plan the Configuration

It is good practice to Run terraform plan to see the changes that will be made by the configuration:

```sh
terraform plan -out=tfplan
```

### 5. Apply the Configuration

If there are no issues after running the plan, apply the Terraform configuration to create the resources using the created plan:

```sh
terraform apply tfplan
```

### 6. Verify the Deployment

After applying the configuration, you can verify the deployment by checking the outputs. The API Gateway URL will be displayed as an output.

## Terraform Resources

### 1. Lambda Function

The lambda.tf file is used to create a Lambda function. It includes the following resources:

1. Creates a zip file containing the source code for the Lambda function at the root of the project - `simple_lambda.zip`.
2. The actual lambda function named - `simple_lambda_${workspace name from setup instructions}`. The lambda uses Node 20 runtime and has 1 environment variable `ENV`.

### 2. S3 Bucket

The s3.tf file creates a single S3 bucket. It includes the following resources:

1. The actual s3 bucket named - `simple-bucket-${workspace name from setup instructions}`.

### 3. HTTP API Gateway

The simple_http_api_gateway.tf file creates an HTTP API Gateway to expose the Lambda function. It includes the following resources:

1. A HTTP API Gateway - we can also use a REST API but for this simple demonstration a HTTP API suffices.
2. Integrates the API Gateway with the Lambda function using the `POST` method. We also use the  `AWS_PROXY` type so that the lambda can handle the request and response.
3. Add a `HTTP POST` route name `/hello` to invoke the Lambda function.
4. A deployment stage for each environment for the API Gateway to ensure that is auto deployed.

### 4. IAM Roles and Policies

The iam.tf creates the IAM roles and policies. It includes the following resources:

1. A IAM role `lambda-role` that (all) lambda functions assume when executing.
2. An IAM policy `full_s3_access_policy` that grants full s3 access to the `simple_static_bucket` s3 bucket. The permission is only granted to one principal:  `simple_lambda_${workspace name from setup instructions}`.
3. An IAM policy `s3_read_access_policy` that grants read access to the `simple_static_bucket` s3 bucket. The permission is only granted to one principal:  `simple_lambda_${workspace name from setup instructions}`.
4. Attaches the `AWSLambdaBasicExecutionRole` to the `lambda-role` to allow the principals (all lambdas) to log to cloudwatch.
5. Attaches the `full_s3_access_policy` to the `lambda-role` to allow the principals (only `simple_lambda_${workspace name from setup instructions}`) full access to the `simple_static_bucket` s3 bucket.
