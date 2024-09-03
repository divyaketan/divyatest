# Map of tags required for AWS resources
# https://confluence.sys.cigna.com/display/CLOUD/AWS+Required+Resource+Tags
required_common_tags = {
  AssetOwner = "BEF_DEVELOPMENT@express-scripts.com"  #Set this to the email address of the owner of this AWS account
  CostCenter = "60031096" #Set to cost center for this project
  SecurityReviewID = "notAssigned" #Set this to the RITM - Number in ServiceNow for the TSE request. Can be set to notAssigned when the solution is in the dev stage
  ServiceNowBA = "notAssigned" #Business Application Number of a Configuration Item in ServiceNow. Can be set to notAssigned when the solution is in the dev stage
  ServiceNowAS = "notAssigned" #Application Service Number within ServiceNow. Can be set to notAssigned when the solution is in the dev stage
}

extra_tags = {
  BackupOwner = "BEF_DEVELOPMENT@express-scripts.com"
  Environment = "dev"
  Purpose = "testing deployment and routing of lambdas"

}

environment                 = "dev"
lambda_executor_role        = "arn:aws:iam::364685145795:role/DEPLOYER"
lambda_alias_release_version_offset = 0
lambda_alias_release_candidate_version_offset = 0

lambda_function_name        = "python-greetings-1"
lambda_iam_policy           = "iam_for_lambda"
lambda_deployment_zip_path  = "./main.zip"
lambda_runtime              = "python3.11"
lambda_handler              = "main.lambda_handler"
lambda_memory_size          = 2048
lambda_timeout_seconds      = 10
alarm_sns_topic_arns        = ["arn:aws:sns:us-east-1:364685145795:cloudwatch-alarm-funnel"]
alarm_app_name              = "bef-File-Storage"
alarm_funnel_app_name       = "bef-File-Storage-dev"  
alarm_thresholds            = {
                                info_error_rate        = 10
                                warn_error_rate        = 15
                                critical_error_rate    = 20
                                info_throttles         = 10
                                warn_throttles         = 20
                                critical_throttles     = 30
                                info_duration_rate     = -1
                                warn_duration_rate     = -1
                                critical_duration_rate = -1
                                info_duration_limit_ms = 2000
                                warn_duration_limit_ms = 3000
                                critical_duration_limit_ms = 5000
                              }

# Intent API Related Configurations Starts
# S3 Bucket
use_default_lc_configuration  = true
enable_bucket_versioning      = true
logging_is_enabled            = false
enable_bucket_keys            = false
crr_is_enabled                = false
enable_crr                    = false
cors_rule_is_enabled          = true
intent_Upload_bucket_name     = "intents-artifacts-364685145795"
cors_allowed_headers          = ["*"]
cors_allowed_methods          = ["POST", "PUT", "GET"]
cors_allowed_origins          = ["*"]

# Lambda Function to get presigned URL
# Need to include only the variables which are specific to this Lambda, all other will be common
intent_lambda_function_name        = "intent-artifacts-get-presigned-url"
intent_lambda_runtime              = "python3.11"
intent_lambda_handler              = "lambda_function.create_presigned_url"
intent_lambda_role_arn             = "arn:aws:iam::364685145795:role/Enterprise/intentApiLambdaS3AccessPolicy"
intent_authorizer_lambda_function_name        = "intent-artifacts-api-authorizer"
intent_authorizer_lambda_handler              = "lambda_function.authorize"
required_data_tags                 = {
                                        DataSubjectArea = "it" # see expected values on confluence page above
                                        ComplianceDataCategory = "none" # see expected values on confluence page above
                                        DataClassification = "internal" # see expected values on confluence page above
                                        BusinessEntity = "healthServices" # see expected values on confluence page above
                                        LineOfBusiness = "healthServices" # see expected values on confluence page above
                                      }
lc_rule_id                          = "s3-default-lifecycle-rule"
aws_primary_accountID               = "364685145795"
intent_apigw_name                   = "intent_artifact_get_presigned_url"
intent_apigw_path                   = "getS3PresignedURL"
aws_wafv2_web_acl_name                          = "intent-api-web-acl"
intent-api-web-acl-ip-set-block-rule-name       = "intent-api-web-acl-ip-set-block-rule-name"
intent-api-web-acl-metrics-blocked-request-name = "intent-api-web-acl-metrics-blocked-request"
intent-api-web-acl-metrics-allowed-request-name = "intent-api-web-acl-metrics-allowed-request"
intent-api-web-acl-black-listed-ipset-name      = "intent-api-web-acl-black-listed-ipset"
intent-api-web-acl-black-listed-ipset           = ["10.211.0.0/30"]
intent-apigw-stage-logging-level                = "INFO"
# Mode info on Authinator - https://confluence.sys.cigna.com/display/AUT/API+Gateway+AWS+Lambda+Integration
intent-authinator-principal-arn                 = "arn:aws:iam::178278630275:role/GATEWAY"
intent_apigw_cloudwatch_role_arn = "arn:aws:iam::364685145795:role/Enterprise/intentApigwCloudwatchLogPush"