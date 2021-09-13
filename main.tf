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
      kubectl create namespace istio-system
      
      # Install the Istio base chart
      helm install istio-base manifests/charts/base -n istio-system
        
      # Install the Istio discovery chart
      helm install istiod manifests/charts/istio-control/istio-discovery -n istio-system
      
      # Install the Istio ingress gateway chart
      helm install istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
      
      # Install the Istio egress gateway chart
      helm install istio-egress manifests/charts/gateways/istio-egress -n istio-system
    EOT
  }
}
