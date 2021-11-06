resource "null_resource" "setup_env" { 
  provisioner "local-exec" { 
    command = <<-EOT
      mkdir ~/.kube || echo "~/.kube already exists"
      echo "${var.aks_kubeconfig}" > ~/.kube/config
      chmod 600 ~/.kube/config
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
      helm install istio-base manifests/charts/base \
        --values ../terraform-kubernetes-istio/chart-values/base-values.yaml \
        --namespace istio-system
        
      # Install the Istio discovery chart
      helm install istiod manifests/charts/istio-control/istio-discovery \
        --values ../terraform-kubernetes-istio/chart-values/discovery-values.yaml \
        --namespace istio-system 
      
      # Install the Istio ingress gateway chart
      helm install istio-ingress manifests/charts/gateways/istio-ingress \
        --values ../terraform-kubernetes-istio/chart-values/ingress-gw-values.yaml \
        --namespace istio-system
      
      # Install the Istio egress gateway chart
      helm install istio-egress manifests/charts/gateways/istio-egress \
        --values ../terraform-kubernetes-istio/chart-values/egress-gw-values.yaml \
        --namespace istio-system

      kubectl -n istio-system patch service istio-egressgateway -p '{"spec": {"type": "LoadBalancer"}}'
      sleep 30
    EOT
  }
}

resource "null_resource" "deploy_bookinfo" {
  count = var.bookinfo_sample_app ? 1 : 0
  depends_on = [null_resource.deploy_istio]
  provisioner "local-exec" {
    command = <<-EOT
      cd istio-${var.istio_version}
      kubectl -n bookinfo apply -f samples/bookinfo/platform/kube/bookinfo.yaml
      kubectl -n bookinfo apply -f ../terraform-kubernetes-istio/istio-manifests/bookinfo.yaml
      kubectl -n bookinfo apply -f ../terraform-kubernetes-istio/istio-manifests/bookinfo-dr.yaml
    EOT
  }
}
