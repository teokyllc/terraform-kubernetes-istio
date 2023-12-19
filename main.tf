resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_version
  namespace  = var.istio_namespace

  set {
    name  = "pilot.replicaCount"
    value = "2"
  }

  set {
    name  = "pilot.autoscaleMin"
    value = "2"
  }

  set {
    name  = "pilot.rollingMaxUnavailable"
    value = "50%"
  }
}

resource "helm_release" "ingress_gateway" {
  depends_on = [helm_release.istiod]
  name       = "ingress-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.istio_version
  namespace  = "istio-system"

  set {
    name  = "replicaCount"
    value = "2"
  }
}
