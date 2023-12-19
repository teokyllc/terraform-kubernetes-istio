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
