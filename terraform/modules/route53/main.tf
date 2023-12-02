resource "aws_route53_zone" "zone" {
  name = "iamparamvirsingh.com"
}

resource "aws_route53_record" "s3site" {
  zone_id = aws_route53_zone.zone.zone_id
  name = "iamparamvirsingh.com"
  type = "A"
  
  alias {
    name = "s3-website.us-east-1.amazonaws.com"
    zone_id = aws_route53_zone.zone.zone_id
    evaluate_target_health = false
  }
}