
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name = "nginx-config"
  }

  data = {
    "nginx.conf" = <<-EOT
      events {}

      http {
          server {
              listen 80;
              location / {
                  return 200 "Pod IP: $server_addr\n";
              }
          }
      }
    EOT
  }
}


resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-client-ip"
    labels = {
      app = "nginx-client-ip"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx-client-ip"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-client-ip"
        }
      }

      spec {
        container {
          name  = "nginx-client-ip"
          image = "nginx:alpine" 
          port {
            container_port = 80
          }

          
          volume_mount {
            name       = "nginx-config-volume"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }
        }

        
        volume {
          name = "nginx-config-volume"
          config_map {
            name = kubernetes_config_map.nginx_config.metadata[0].name
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-client-ip"
  }

  spec {
    selector = {
      app = "nginx-client-ip"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer" 
  }
}


resource "kubernetes_horizontal_pod_autoscaler" "nginx" {
  metadata {
    name = "nginx-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 10

    
    metric {
      type = "Resource"

      resource {
        name   = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 50  
        }
      }
    }
  }
}
