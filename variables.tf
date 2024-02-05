variable "istio_namespace" {
  type        = string
  description = "The namespace for the Istio deployment."
  default     = "istio-system"
}

variable "istio_version" {
  type        = string
  description = "The version of Istio to deploy."
  default     = null
}

variable "istiod_replica_count" {
  type        = string
  description = "The number of replicas for the istiod pod."
  default     = null
}

variable "ingress_gateway_replica_count" {
  type        = string
  description = "The number of replicas for the istio ingress gateway pod."
  default     = null
}

variable "create_tls_certificate" {
  type        = bool
  description = "If true, creates a TLS certificate in the istio namespace."
  default     = false
}

variable "tls_certificate_name" {
  type        = string
  description = "The name of the cert-manager TLS certificate."
  default     = null
}

variable "certificate_dns_names" {
  type        = list(any)
  description = "A list of DNS names for the TLS certificate."
  default     = null
}

variable "cluster_issuer_name" {
  type        = string
  description = "The name of the cert-manager ClusterIssuer."
  default     = null
}

variable "tls_secret_name" {
  type        = string
  description = "The name of the certificate underlying secret."
  default     = null
}