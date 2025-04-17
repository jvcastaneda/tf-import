############################################
# Outputs
############################################

output "iam_output" {
  description = "IAM output"
  value       = aws_iam_role.prometheus.arn
  depends_on  = [aws_iam_role_policy.prometheus]
}
