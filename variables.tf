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

variable "istiod_access_logs_enabled" {
  type        = bool
  description = "Enables Envoy access logging."
  default     = null
}

variable "istiod_access_logs_enabled_retention" {
  type        = string
  description = "The amount of time to keep access logs."
  default     = null
}

variable "ingress_gateway_replica_count" {
  type        = string
  description = "The number of replicas for the istio ingress gateway pod."
  default     = null
}