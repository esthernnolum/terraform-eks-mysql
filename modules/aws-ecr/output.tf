output "repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.myecr-assess.repository_url
}
output "repository_registry_id" {
  description = "Registry ID where the repo was created"
  value       = aws_ecr_repository.myecr-assess.registry_id
}