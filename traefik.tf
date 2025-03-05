resource "docker_image" "traefik" {
  name = "traefik:v3.2"
}

resource "docker_container" "traefik" {
  name          = "traefik-core"
  image         = docker_image.traefik.image_id
  network_mode  = "bridge"

  volumes {
    host_path       = "/var/run/docker.sock"
    container_path  = "/var/run/docker.sock"
    read_only       = false
  }

  volumes {
    host_path       = "/home/keegan/homelab/core/traefik/traefik.yaml"
    container_path  = "/etc/traefik/traefik.yaml"
    read_only       = false
  }

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = "core-network"
  }

  labels {
    key   = "traefik.enable"
    value = "true"
  }

  labels {
    key   = "traefik.http.routers.traefik-internal-router.rule"
    value = "Host(\"traefik.keegan.boston\")"
  }

  labels {
    key   = "traefik.http.routers.traefik-internal-router.entrypoints"
    value = "websecure"
  }

  labels {
    key   = "traefik.http.routers.traefik-internal-router.tls"
    value = "true"
  }

  labels {
    key   = "traefik.http.routers.traefik-internal-router.tls.certresolver"
    value = "myresolver"
  }

  labels {
    key   = "traefik.http.services.traefik-service.loadbalancer.server.port"
    value = "8080"
  }
}

