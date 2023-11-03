resource "shoreline_notebook" "azure_webapp_certificate_renewal_failures" {
  name       = "azure_webapp_certificate_renewal_failures"
  data       = file("${path.module}/data/azure_webapp_certificate_renewal_failures.json")
  depends_on = [shoreline_action.invoke_upload_ssl_certificate]
}

resource "shoreline_file" "upload_ssl_certificate" {
  name             = "upload_ssl_certificate"
  input_file       = "${path.module}/data/upload_ssl_certificate.sh"
  md5              = filemd5("${path.module}/data/upload_ssl_certificate.sh")
  description      = "Manually renew an SSL certificate"
  destination_path = "/tmp/upload_ssl_certificate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_upload_ssl_certificate" {
  name        = "invoke_upload_ssl_certificate"
  description = "Manually renew an SSL certificate"
  command     = "`chmod +x /tmp/upload_ssl_certificate.sh && /tmp/upload_ssl_certificate.sh`"
  params      = ["CERTIFICATE_PASSWORD","CERTIFICATE_FILE_PATH","APP_NAME","RESOURCE_GROUP"]
  file_deps   = ["upload_ssl_certificate"]
  enabled     = true
  depends_on  = [shoreline_file.upload_ssl_certificate]
}

