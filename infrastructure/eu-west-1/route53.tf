
resource "aws_route53_zone" "gaf-zone" {
  depends_on = [module.eks]
  name       = var.zone-name
}

