variable "token" {}
variable "username" {}
variable "size" {}
variable "nodes" {}

provider "digitalocean" {
  token = "${var.token}"
}

locals {
  clean_username = "${replace(var.username, ".", "")}"
  cluster_name   = "${local.clean_username}s-cluster"
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${local.cluster_name}"
  region  = "fra1"
  version = "1.12.1-do.2"
  tags    = ["${local.clean_username}"]

  node_pool {
    name       = "woker-pool"
    size       = "${var.size}"
    node_count = "${var.nodes}"
  }
}

# provider "kubernetes" {
#   host = "${digitalocean_kubernetes_cluster.cluster.endpoint}"

#   client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_certificate)}"
#   client_key             = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_key)}"
#   cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)}"
# }

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/kubeconfig-template.yaml")}"

  vars {
    name            = "${local.cluster_name}"
    endpoint        = "${digitalocean_kubernetes_cluster.cluster.endpoint}"
    tls_authority   = "${digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate}"
    tls_certificate = "${digitalocean_kubernetes_cluster.cluster.kube_config.0.client_certificate}"
    tls_key         = "${digitalocean_kubernetes_cluster.cluster.kube_config.0.client_key}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.module}/kubeconfig.yaml"
}
