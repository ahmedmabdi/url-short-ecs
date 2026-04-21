resource "aws_s3_bucket" "codedeploy_artifacts" {
  bucket = "codedeploy-artifacts-ecs"

  tags = {
    Name        = "codedeploy-artifacts"
    Environment = "shared"
  }
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.codedeploy_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}