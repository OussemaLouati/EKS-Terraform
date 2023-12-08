# resource "aws_eip" "openvpn" {
#   instance = module.openvpn_ec2_instance.id
#   vpc      = true
# }

# resource "aws_route53_record" "openvpn" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = "openvpn.example.com"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_eip.openvpn.public_ip]
# }
