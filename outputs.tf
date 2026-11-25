output "container_names" {
  value = docker_container.this[*].name
}

output "urls" {
  value = [for i in range(var.container_count) : "http://localhost:${var.start_port + i}"]
}
