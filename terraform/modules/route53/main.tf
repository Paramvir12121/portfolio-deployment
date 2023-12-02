resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "s3site" {
  zone_id = aws_route53_zone.zone.zone_id
  name = var.domain_name
  type = "A"
  
  alias {
    name = "s3-website.us-east-1.amazonaws.com"
    zone_id = aws_route53_zone.zone.zone_id
    evaluate_target_health = false
  }
}