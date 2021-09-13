  
variable "aks_kubeconfig" {
    type = string
    description = "The kubeconfig file from the AKS cluster."
}

variable "istio_version" {
    type = string
    description = "The version of Istio to deploy."
}
