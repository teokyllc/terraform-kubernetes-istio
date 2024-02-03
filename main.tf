resource "helm_release" "istio_base" {
  name             = "base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.istio_version
  namespace        = var.istio_namespace
  create_namespace = true

  set {
    name  = "global.istioNamespace"
    value = var.istio_namespace
  }
}

resource "helm_release" "istiod" {
  depends_on = [helm_release.istio_base]
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_version
  namespace  = var.istio_namespace

  set {
    name  = "pilot.replicaCount"
    value = var.istiod_replica_count
  }

  set {
    name  = "pilot.autoscaleMin"
    value = var.istiod_replica_count
  }

  set {
    name  = "pilot.rollingMaxUnavailable"
    value = "50%"
  }

  set {
    name  = "telemetry.v2.accessLogPolicy.enabled"
    value = var.istiod_access_logs_enabled
  }

  set {
    name  = "telemetry.v2.accessLogPolicy.logWindowDuration"
    value = var.istiod_access_logs_enabled_retention
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
    value = var.ingress_gateway_replica_count
  }
}
