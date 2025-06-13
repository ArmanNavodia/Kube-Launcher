resource "kubernetes_ingress_v1" "grafana_ingress" {
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "monitoring.local"
      http {
        path {
          path     = "/garfana"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana-service"
              port {
                number = 80
              }
            }
          }
        }
        path {
          path     = "/prometheus"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
