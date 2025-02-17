/**
 * This file creates an S3 bucket and grants the lambda full permissions to all the bucket's resources (read, write, delete)
 * 
 * @module root
 */

// Create the S3 bucket
resource "aws_s3_bucket" "simple_static_bucket" {
  bucket = "simple-static-bucket-${terraform.workspace}"
}

