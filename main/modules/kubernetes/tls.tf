# resource "kubernetes_secret" "tls-cert" {
#     metadata {
#         name = "tls-cert"
#         namespace = var.project-namespace
#     }
#     data = {
#         "tls.crt" = "${var.tls-crt}"
#         "tls.key" = "${var.tls-key}"
#     }
#     type = "kubernetes.io/tls"
# }