provider "aws" {
    region = "us-east-2"
}

resource "aws_iam_role" "prometheus" {
    name = "PrometheusServiceRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Federated = "arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}"
                },
                Action = "sts:AssumeRoleWithWebIdentity",
                Condition = {
                    StringEquals = {
                        "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub": "system:serviceaccount:${var.namespace}:${var.service_account_name}"
                    }
                }
            }
        ]
    })
}

resource "aws_iam_role_policy" "prometheus" {
    name   = "PrometheusServiceRole-policy"
    role   = aws_iam_role.prometheus.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow",
                Action   = [
                    "ec2:DescribeRegions",
                    "ec2:DescribeInstances",
                    "ec2:DescribeTags"
                ],
                Resource = "*"
            }
        ]
    })
}