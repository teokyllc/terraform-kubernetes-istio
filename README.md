# terraform-kubernetes-istio
This is a Terraform module deploys an Istio service mesh on Kubernetes.<br>
[Istio](https://istio.io/latest/docs/)<br>
[Istio Ingress Gateway](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/)<br>
[Terraform Helm Release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)<br>

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "istio" {
  source = "github.com/teokyllc/terraform-kubernetes-istio"
  ...
```
<br>

<b>Tagged release</b><br>

```
module "istio" {
  source = "github.com/teokyllc/terraform-kubernetes-istio?ref=1.0"
  ...
```
<br>

## Examples of using this module
This is an example of using this module to deploy the Istio service mesh.<br>

```
module "istio" {
  source = "github.com/teokyllc/terraform-kubernetes-istio?ref=1.0"
  istio_namespace = "istio-system"
  istio_version   = "1.16.2"
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/teokyllc/terraform-kubernetes-istio.git
cd terraform-kubernetes-istio

cat <<EOF > istio.auto.tfvars
istio_namespace = "istio-system"
istio_version   = "1.16.2"
EOF

terraform init
terraform apply
```