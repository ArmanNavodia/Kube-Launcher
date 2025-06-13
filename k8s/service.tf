resource "kubernetes_service" "flask-service" {
  metadata {
    name = "flask-service"
  }
  spec {
    selector = {
      App = "flask-app"
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "clusterIP"
  }
}