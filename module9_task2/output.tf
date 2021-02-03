output "production" {
  value = try(element(aws_instance.server.*.public_dns, index(keys(var.configuration), "production")), "")
}

output "jenkins" {
  value = try(element(aws_instance.server.*.public_dns, index(keys(var.configuration), "jenkins")), "")
}

output "jenkins-agent" {
  value = try(element(aws_instance.server.*.public_dns, index(keys(var.configuration), "jenkins-agent")), "")
}
