resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  count      = var.container_count
  name       = "${var.name_prefix}-${count.index}"
  hostname   = "${var.name_prefix}-${count.index}"
  image      = docker_image.this.image_id
  memory     = var.memory
  privileged = var.privileged

  ports {
    internal = var.internal_port
    external = var.start_port + count.index
  }

  # Bonus Lab 1 : page affichant le hostname, seulement si l'image est nginx
  dynamic "upload" {
    for_each = startswith(var.image, "nginx") ? [1] : []
    content {
      file    = "/etc/nginx/conf.d/default.conf"
      content = <<-EOF
        server {
          listen 80;
          location / {
            default_type text/html;
            return 200 "<h1>Hello from $hostname</h1>\n";
          }
        }
      EOF
    }
  }
}
