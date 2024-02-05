resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.ingress_gateway]
  create_duration = "30s"
}


data "kubernetes_service_v1" "istio_ingress_gateway" {
  depends_on = [time_sleep.wait_30_seconds, helm_release.ingress_gateway]
  metadata {
    name      = "ingress-gateway"
    namespace = "istio-system"
  }
}