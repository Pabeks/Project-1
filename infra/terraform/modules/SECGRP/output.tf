output "ext-alb-sg" {
  value = aws_security_group.paje["ext-alb-sg"].id
}


output "int-alb-sg" {
  value = aws_security_group.paje["int-alb-sg"].id
}


output "bastion-sg" {
  value = aws_security_group.paje["bastion-sg"].id
}


output "nginx-sg" {
  value = aws_security_group.paje["nginx-sg"].id
}


output "web-sg" {
  value = aws_security_group.paje["webserver-sg"].id
}


output "datalayer-sg" {
  value = aws_security_group.paje["datalayer-sg"].id
}

output "compute-sg" {
  value = aws_security_group.paje["compute-sg"].id
}