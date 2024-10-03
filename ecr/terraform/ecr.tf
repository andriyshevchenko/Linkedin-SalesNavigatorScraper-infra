resource "aws_ecr_repository" "linkedin_sales_navigator_scraper_repository" {
  name                 = local.ecr_name
  image_tag_mutability = "MUTABLE" # "MUTABLE" or "IMMUTABLE" depending on your requirements
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.linkedin_sales_navigator_scraper_repository.repository_url
  description = "The URL of the created ECR repository"
}
