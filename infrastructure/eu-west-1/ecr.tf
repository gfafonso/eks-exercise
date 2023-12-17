
resource "aws_ecr_repository" "gaf-ecr-be" {
  depends_on = [ module.eks ]
  name = "gaf-ecr-be"
}

resource "aws_ecr_repository" "gaf-ecr-fe" {
  depends_on = [ module.eks ]
  name = "gaf-ecr-fe"
}

data "aws_iam_policy_document" "pushpull-ecr-policy" {
  statement {
    sid    = "new policy"
    effect = "Allow"
  
  principals {
      type        = "AWS"
      identifiers = [module.eks_managed_node_group.iam_role_arn]
  }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "repository-policy-fe" {
  repository = aws_ecr_repository.gaf-ecr-fe.name
  policy     = data.aws_iam_policy_document.pushpull-ecr-policy.json
}

resource "aws_ecr_repository_policy" "repository-policy-be" {
  repository = aws_ecr_repository.gaf-ecr-be.name
  policy     = data.aws_iam_policy_document.pushpull-ecr-policy.json
}