resource "aws_dynamodb_table" "this" {
  name           = var.dynamodb_table_name
  billing_mode   = var.dynamodb_billing_mode

  hash_key       = var.dynamodb_hash_key
  
  point_in_time_recovery {
      enabled = var.pitr_enabled
    }

  attribute {
    name = var.dynamodb_attribute_name
    type = var.dynamodb_attribute_type
  }

  ttl {
    attribute_name = var.dynamodb_ttl_attribute_name
    enabled        = var.dynamodb_ttl_enabled
  }

  tags = {
    Name = "${var.tag_name}-table"
  }
}