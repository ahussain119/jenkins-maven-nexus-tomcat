variable "domain_name" {}
variable "jenkins_ip_address" {}
variable "nexus_ip_address" {}
variable "tomcat_ip_address" {}
variable "maven_ip_address" {}

output "certificate_arn" {
    value = aws_acm_certificate.certificate.arn  
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.route53_zone.zone_id
}

data "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "jenkins_zone_record" {
    zone_id = data.aws_route53_zone.route53_zone.zone_id
    name    = "jen.${var.domain_name}"
    type    = "A"
    ttl     = 300
    records = [ var.jenkins_ip_address ]
    
}

resource "aws_route53_record" "nexus_zone_record" {
    zone_id = data.aws_route53_zone.route53_zone.zone_id
    name    = "nexus.${var.domain_name}"
    type    = "A"
    ttl     = 300
    records = [ var.nexus_ip_address ]  
}


resource "aws_route53_record" "maven_zone_record" {
    depends_on = [ aws_route53_record.tomcat ]
    zone_id = data.aws_route53_zone.route53_zone.zone_id
    name    = "maven.${var.domain_name}"
    type    = "A"
    ttl     = 300
    records = [ var.maven_ip_address ]  
}

resource "aws_route53_record" "tomcat" {
  zone_id = data.aws_route53_zone.route53_zone.id
  name = var.domain_name 
  type = "A"
  ttl     = 300
  records = [ var.tomcat_ip_address ]
}

resource "aws_acm_certificate" "certificate" {
    depends_on = [aws_route53_record.jenkins_zone_record, aws_route53_record.nexus_zone_record, aws_route53_record.tomcat]
    domain_name              = var.domain_name
    subject_alternative_names = ["jen.${var.domain_name}", "nexus.${var.domain_name}", "maven.${var.domain_name}"]
    validation_method        = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  depends_on      = [ aws_route53_record.validation_record ]
  validation_record_fqdns = [ for record in aws_route53_record.validation_record : record.fqdn ]
}