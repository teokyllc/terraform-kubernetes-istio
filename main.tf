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
}

resource "helm_release" "ingress_gateway" {
  depends_on = [helm_release.istiod]
  name       = "ingress-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.istio_version
  namespace  = var.istio_namespace

  set {
    name  = "replicaCount"
    value = var.ingress_gateway_replica_count
  }

  set {
    name  = "autoscaling.minReplicas"
    value = var.ingress_gateway_replica_count
  }
}

resource "kubernetes_manifest" "tls_certificate" {
  count      = var.create_tls_certificate ? 1 : 0
  depends_on = [helm_release.ingress_gateway]
  manifest   = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata"   = {
      "name"      = var.tls_certificate_name
      "namespace" = var.istio_namespace
    }
    "spec" = {
      "dnsNames"  = var.certificate_dns_names
      "issuerRef" = {
        "group" = "cert-manager.io"
        "kind"  = "ClusterIssuer"
        "name"  = var.cluster_issuer_name
      }
      "secretName" = var.tls_secret_name
      "renewBefore" = "360h0m0s"
      "usages"     = [
        "digital signature",
        "key encipherment",
      ]
    }
  }

  field_manager {
    force_conflicts = true
  }
}
