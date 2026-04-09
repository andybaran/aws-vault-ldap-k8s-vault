data "aws_secretsmanager_secret_version" "this" {
  count     = var.secret_arn == null ? 0 : 1
  secret_id = var.secret_arn
}

locals {
  payload = var.secret_arn == null ? null : jsondecode(data.aws_secretsmanager_secret_version.this[0].secret_string)
}
