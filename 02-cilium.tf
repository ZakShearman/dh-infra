resource "kubernetes_namespace" "cilium" {
  metadata {
    name = "cilium"

    labels = {
      "pod-security.kubernetes.io/enforce" : "privileged",
      "pod-security.kubernetes.io/audit" : "privileged",
      "pod-security.kubernetes.io/warn" : "privileged",
    }
  }
}

resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.19.1"
  namespace  = "cilium"

  create_namespace = false

  values = [
    file("./files/cilium-values.yaml")
  ]

  wait    = true
  atomic  = true
  timeout = 300

  depends_on = [kubernetes_namespace.cilium]
}
