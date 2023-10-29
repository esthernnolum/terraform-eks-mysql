# Create an Elastic Container Registry (ECR)
resource "aws_ecr_repository" "myecr-assess" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
