resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "app-ingress"
    namespace = "default"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "app.local"
      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "flask-service"
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
