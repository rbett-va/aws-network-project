output "lb_security_group" {
  value = aws_security_group.lb_security_group.id
}

output "ctn_security_group" {
  value = aws_security_group.ctn_security_group.id
}
