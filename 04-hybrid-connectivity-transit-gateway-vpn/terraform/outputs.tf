output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "vpn_connection_id" {
  value = aws_vpn_connection.vpn.id
}
