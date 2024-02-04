output "istiod_release_name" {
  value = helm_release.istiod.metadata[0].name
}

output "istiod_release_revision" {
  value = helm_release.istiod.metadata[0].revision
}

output "ingress_gateway_release_name" {
  value = helm_release.ingress_gateway.metadata[0].name
}

output "ingress_gateway_release_revision" {
  value = helm_release.ingress_gateway.metadata[0].revision
}

output "ingress_gateway_hostname" {
  value = data.kubernetes_service.example.status.0.load_balancer.0.ingress.0.hostname
}

output "ingress_gateway_istio_label" {
  value = helm_release.ingress_gateway.metadata[0].name
}