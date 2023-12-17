
resource "aws_iam_user" "eks-poweruser" {
    name = var.poweruser-username
}

resource "aws_iam_user_policy_attachment" "eks-poweruser-attach" {
  user       = aws_iam_user.eks-poweruser.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_access_key" "poweruser-access_key" {
  user    = aws_iam_user.eks-poweruser.name
  status  = var.status
}
