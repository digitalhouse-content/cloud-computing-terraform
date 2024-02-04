output "vpc_id" {
  value = aws_vpc.vpc.id
  description = "ID de la VPC vpc-cloud"
}

output "subnet_public_1" {
  value = aws_subnet.subnet_public_1.id
  description = "Subnet Pública 1"
}

output "subnet_public_2" {
  value = aws_subnet.subnet_public_2.id
  description = "Subnet Pública 2"
}

output "subnet_private_1" {
  value = aws_subnet.subnet_private_1.id
  description = "Subnet Privada 1"
}

output "subnet_private_2" {
  value = aws_subnet.subnet_private_2.id
  description = "Subnet Privada 2"
}

output "ecr_url" {
  value = aws_ecr_repository.ecr_cloud.repository_url
  description = "URI de repositorio de docker cloud-webapp-rickandmorty"
}