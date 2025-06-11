# 1. Customer Gateway (온프렘 IP 필요)
resource "aws_customer_gateway" "on_prem" {
  bgp_asn    = 65000                   # 정적 라우팅이면 아무 번호 가능
  ip_address = var.customer_gateway_ip # 온프렘 공인 IP
  type       = "ipsec.1"

  tags = {
    Name = "OnPrem-CGW"
  }
}

# 2. Virtual Private Gateway
resource "aws_vpn_gateway" "vgw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Main-VGW"
  }
}


# 3. VPN Connection
resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = aws_customer_gateway.on_prem.id
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  type                = "ipsec.1"
  static_routes_only  = true # 정적 라우팅 사용 시 true

  tags = {
    Name = "OnPrem-VPN-Connection"
  }
}

# 4. VPN Connection Static Routes
resource "aws_vpn_connection_route" "on_prem_route" {
  vpn_connection_id      = aws_vpn_connection.vpn.id
  destination_cidr_block = var.on_prem_cidr_block
}

# 5. Route Table 업데이트 (Private 서브넷 → 온프렘 CIDR)
resource "aws_route" "to_on_prem" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.on_prem_cidr_block
  gateway_id             = aws_vpn_gateway.vgw.id
}


