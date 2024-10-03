# Create IAM group
resource "aws_iam_group" "ecr_access_group" {
  name = "ECRAccessGroup"
}

# Attach the ECR Pull/Push policy to the IAM group
resource "aws_iam_group_policy_attachment" "ecr_group_policy_attachment" {
  group      = aws_iam_group.ecr_access_group.name
  policy_arn = aws_iam_policy.ecr_pull_push_policy.arn

  # Explicit dependency to ensure the policy is created before attaching
  depends_on = [aws_iam_policy.ecr_pull_push_policy]
}