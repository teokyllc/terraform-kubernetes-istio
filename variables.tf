variable "aks_kubeconfig" {
    type = string
    description = "The kubeconfig file from the AKS cluster."
}

variable "istio_version" {
    type = string
    description = "The version of Istio to deploy."
}

variable "bookinfo_sample_app" {
    type = bool
    description = "If enabled this will deploy the book info sample micro service."
}

variable "kiali_mgmt_console" {
    type = bool
    description = "If enabled this will deploy a management console for Istio service mesh."
}
