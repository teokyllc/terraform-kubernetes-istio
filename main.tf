resource "null_resource" "setup_env" { 
  provisioner "local-exec" { 
    command = <<-EOT
      mkdir ~/.kube || echo "~/.kube already exists"
      echo "${var.aks_kubeconfig}" > ~/.kube/config
    EOT
  }
}

resource "null_resource" "deploy_istio" {
  depends_on = [null_resource.setup_env]
  provisioner "local-exec" {
    command = <<-EOT
      curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${var.istio_version} TARGET_ARCH=x86_64 sh 
      cd istio-${var.istio_version}
      
      # Install the Istio base chart
      helm install istio-base manifests/charts/base --values ../terraform-kubernetes-istio/base-values.yaml --namespace istio-system
        
      # Install the Istio discovery chart
      helm install istiod manifests/charts/istio-control/istio-discovery --values ../terraform-kubernetes-istio/discovery-values.yaml --namespace istio-system 
      
      # Install the Istio ingress gateway chart
      helm install istio-ingress manifests/charts/gateways/istio-ingress --values ../terraform-kubernetes-istio/ingress-gw-values.yaml --namespace istio-system
      
      # Install the Istio egress gateway chart
      helm install istio-egress manifests/charts/gateways/istio-egress --values ../terraform-kubernetes-istio/egress-gw-values.yaml --namespace istio-system
    EOT
  }
}

