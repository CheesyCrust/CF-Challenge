#############
# EC2 Perms
#############

resource "aws_iam_role" "POCallowSSM" {
    name = "POC-Allow-SSM"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "POC-Bucket-Policy" {
  name        = "POC-Bucket-Policy"
  path        = "/"
  description = "Allows for writing to bucket LOGS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment-standalone" {
    role = aws_iam_role.POCallowSSM.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "POCallowSSM-Profile" {
    name = "POC-Allow-SSM"
    role = aws_iam_role.POCallowSSM.name
}

resource "aws_iam_role" "POC-ALB-Allow" {
    name = "POC-ALB-Allow"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment-alb" {
    role = aws_iam_role.POC-ALB-Allow.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "POC-ALB-Allow-Profile" {
    name = "POC-ALB-Allow"
    role = aws_iam_role.POC-ALB-Allow.name
}