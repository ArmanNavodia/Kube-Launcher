resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}


resource "helm_release" "prometheus_stack" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"

  create_namespace = false

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]
}