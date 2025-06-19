data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx" # or your nginx namespace
  }
}

locals {
  lb_dns = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
}

resource "kubernetes_ingress_v1" "grafana_ingress" {
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"
    annotations = {
       "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      # "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "grafana.<your-domain>"
      http {
        path {
          path      = "/"
          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }
        }


        path {
          path      = "/prometheus"
          path_type = "Prefix"
          backend {
            service {
              name = "kube-prometheus-stack-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}
