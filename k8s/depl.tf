resource "kubernetes_deployment" "flask-app" {
  metadata {
    name = "flask-app"
    labels = {
      App = "flask-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "flask-app"
      }
    }
    template {
      metadata {
        labels = {
          App = "flask-app"
        }
      }
      spec {
        container {
          image = "905418225755.dkr.ecr.ap-south-1.amazonaws.com/flask-app:latest"
          name  = "flask-app"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}
