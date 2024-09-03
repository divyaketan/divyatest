# /* 
#   Intent API - Artifacts upload Infra Configs
#   Consists of below AWS resources - 
#     - S3 bucket - to store Artifacts
#     - Lambda - To get presigned URL to upload file
#     - API Gateway - Endpoint for external APIs to invoke Lambda
# */

# # S3 Bucket related configs
# data "aws_iam_policy_document" "intent_artifact_bucket_policy" {
#   statement {
#     sid = "intent_bucket_policy"
#     principals {
#       identifiers = ["${data.aws_caller_identity.current.id}"]
#       type        = "AWS"
#     }
#     actions = [
#       "s3:Get*",
#       "s3:List*",
#       "s3:Put*",
#       "s3:Delete*",
#       "s3:GetObject*",
#     ]
#     resources = [
#       "arn:aws:s3:::${var.intent_Upload_bucket_name}",
#       "arn:aws:s3:::${var.intent_Upload_bucket_name}/*"
#     ]
#   }
# }

# module "intent_upload_s3" {
#   source = "git::https://github.sys.cigna.com/cigna/terraform-aws-s3"
#   bucket_name = var.intent_Upload_bucket_name
#   required_tags     = var.required_common_tags
#   optional_tags     = var.extra_tags
#   required_data_tags = var.required_data_tags
#   lc_rule_id        = var.lc_rule_id
#   bucket_policy = data.aws_iam_policy_document.intent_artifact_bucket_policy.json
#   providers = {
#     aws.replication = aws.crr
#     aws.source      = aws
#   }
#   cors_rule_is_enabled = var.cors_rule_is_enabled
#   cors_allowed_headers = var.cors_allowed_headers
#   cors_allowed_methods = var.cors_allowed_methods
#   cors_allowed_origins = var.cors_allowed_origins
# }
# # --- S3 Config Ends ---

# /* ---- Intent API Infra config ends --- */

