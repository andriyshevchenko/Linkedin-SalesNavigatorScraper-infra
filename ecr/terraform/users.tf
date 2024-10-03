# Create IAM user
resource "aws_iam_user" "github_user" {
  name = "github"
}

# Add the user to the ECR access group, ensure the group exists before adding the user
resource "aws_iam_user_group_membership" "github_user_group_membership" {
  user = aws_iam_user.github_user.name
  groups = [
    aws_iam_group.ecr_access_group.name
  ]

  depends_on = [aws_iam_user.github_user, aws_iam_group.ecr_access_group]
}

# Optionally, create access keys for the user (used for programmatic access)
resource "aws_iam_access_key" "github_access_key" {
  user = aws_iam_user.github_user.name

  lifecycle {
    prevent_destroy = true # Prevent accidental deletion of the access key
  }

  depends_on = [aws_iam_user.github_user] # Ensure the user exists before creating access keys
}

# Create a secret in AWS Secrets Manager for the GitHub access keys
resource "aws_secretsmanager_secret" "github_access_keys" {
  name = "github-access-keys"
}

# Store the secret value (access key and secret access key) in the secret
resource "aws_secretsmanager_secret_version" "github_access_keys_version" {
  secret_id = aws_secretsmanager_secret.github_access_keys.id

  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.github_access_key.id
    secret_access_key = aws_iam_access_key.github_access_key.secret
  })

  depends_on = [aws_iam_access_key.github_access_key]
}
