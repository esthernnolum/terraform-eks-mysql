output "repository_url" {
  description = "The repository url"
  value       = aws_ecr_repository.ecr-assess.repository_url
}
output "repository_registry_id" {
  description = "Registry ID where the repo was created"
  value       = aws_ecr_repository.ecr-assess.registry_id
}
output "repository_arn" {
  description = "The ARN of the repository"
  value       = aws_ecr_repository.ecr-assess.arn
}