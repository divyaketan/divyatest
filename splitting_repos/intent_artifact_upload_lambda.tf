
# /* 
#   Intent API - Artifacts upload Infra Configs
#   Consists of below AWS resources - 
#     - S3 bucket - to store Artifacts
#     - Lambda - To get presigned URL to upload file
#     - API Gateway - Endpoint for external APIs to invoke Lambda
# */

# # Lambda related configurations
# # Code module
# data "archive_file" "intent_artifact_lambda_package" {
#   type = "zip"
#   source_file = "${path.module}/intent_lambda/lambda_function.py"
#   output_path = "${path.module}/intent_lambda/get_presigned_url.zip"
# }

# # Lambda Function
# module "intent_upload_lambda" {
#   source = "git::https://github.sys.cigna.com/cigna/lambda.git?ref=1.4.0"
#   function_name     = var.intent_lambda_function_name
#   filename          = data.archive_file.intent_artifact_lambda_package.output_path
#   source_code_hash  = data.archive_file.intent_artifact_lambda_package.output_base64sha256
#   handler           = var.intent_lambda_handler
#   runtime           = var.intent_lambda_runtime
#   memory_size       = var.lambda_memory_size
#   timeout           = var.lambda_timeout_seconds
#   required_tags     = var.required_common_tags
#   optional_tags     = var.extra_tags
#   alarm_env         = var.environment
#   alarm_app_name    = var.alarm_app_name
#   alarm_sns_topic_arns = var.alarm_sns_topic_arns
#   alarm_thresholds  = var.alarm_thresholds
#   alarm_funnel_app_name = var.alarm_funnel_app_name
#   security_group_ids = []
#   role_arn = var.intent_lambda_role_arn
#   depends_on = [ data.archive_file.intent_artifact_lambda_package ] # Can start only after package creation completes
# }


# # Lambda Permission to invoke from API GW
# resource "aws_lambda_permission" "intent_apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name =  module.intent_upload_lambda.function_name #aws_lambda_function.lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn    = "arn:aws:execute-api:${var.aws_region_primary}:${var.aws_primary_accountID}:${aws_api_gateway_rest_api.intent_api_gw.id}/*/*${aws_api_gateway_resource.intent_api_gw_resource.path}"
# }

# # Lambda Invoke permission for Authinator API
# resource "aws_lambda_permission" "intent_authinator_lambda" {
#   statement_id  = "GATEWAY"
#   action        = "lambda:InvokeFunction"
#   function_name =  module.intent_upload_lambda.function_name #aws_lambda_function.lambda.function_name
#   principal     = var.intent-authinator-principal-arn
# }
# # --- Lambda Config ends ---

# /* ---- Intent API Infra config ends --- */

