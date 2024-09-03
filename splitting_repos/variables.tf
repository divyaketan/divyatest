#######
#
# API gateway config
#
variable "environment"{
  description = "What environment is this representing?"
  type = string
  default = "unknown"
}

#######
#
# Blue Green Stuff
#
variable "lambda_alias_release_version_offset" {
  description = "The offset for the version that will be used for the alias on release"
  type = number
  default = 0
}

variable "lambda_alias_release_candidate_version_offset" {
  description = "The offset for the version that will be used for the alias on release candidate"
  type = number
  default = 0
}

#######
#
# Lambda config
#

variable "lambda_function_name"{
  description = "The name for the lambda function"
  type = string
  default = ""
}

variable "lambda_executor_role"{
  description = "The role that will be given privileges to execute this lambda"
  type = string
  default = ""
}

variable "lambda_iam_policy"{
  description = "IAM Policy name"
  type = string
  default = ""
}

variable "lambda_deployment_zip_path"{
  description = "The local path of the zip file that will be deployed as a lambda"
  type = string
  default = ""
}

variable "lambda_handler"{
  description = "The start of the execution path for the lambda"
  type = string
  default = "example"
}

variable "lambda_memory_size"{
  description = "How much ram to allocate for the lambda"
  type = number
  default = 256
}

variable "lambda_runtime"{
  description = "How much ram to allocate for the lambda"
  type = string
  default = "nodejs12.x"
}

variable "lambda_timeout_seconds"{
  description = "How much time until the invocation times out"
  type = number
  default = 30
}

#######
#
# Alarm Setup
#

variable "alarm_sns_topic_arns"{
  description = "The ARNs for the SNS topic to send alarms to"
  default = []
}

variable "alarm_app_name"{
  description = "The app name for alarms"
  type = string
  default = ""
}

variable "alarm_funnel_app_name" {
  description = "Application name as configured in the alarm funnel project"
  type        = string
}

variable "alarm_thresholds" {
  description = "Thresholds for Lambda alarms. Set to -1 if you do not want the alarm."
  default = {
    info_error_rate             = 10
    warn_error_rate             = -1
    critical_error_rate         = 20
    info_throttles              = 10
    warn_throttles              = 20
    critical_throttles          = -1
    info_duration_rate          = -1
    warn_duration_rate          = -1
    critical_duration_rate      = -1
    info_duration_limit_ms      = -1
    warn_duration_limit_ms      = -1
    critical_duration_limit_ms  = -1
  }
}
#######
#
# Tags
#
variable "required_common_tags" {
  description = "Required common resource tags as defined by the AWS Resource Tagging Requirements spec"
  type = object({
    AssetOwner        = string
    CostCenter        = string
    ServiceNowBA      = string
    ServiceNowAS      = string
    SecurityReviewID  = string
  })

  validation {
    condition = alltrue([
      var.required_common_tags.AssetOwner != "",
      var.required_common_tags.CostCenter != "",
      var.required_common_tags.ServiceNowBA != "",
      var.required_common_tags.ServiceNowAS != "",
      var.required_common_tags.SecurityReviewID != ""
    ])
    error_message = "Required tags cannot be empty."
  }
}

variable "extra_tags" {
  description = "Map of custom tags to apply to resources"
  type        = map(string)
  default     = {}
}

## Behaviors ##
variable "extra_behaviors" {
  description = "Map of cloudfront behaviors"
  type = list(object({
    path_pattern = string
    origin_name = string
    lambdas = list(object({
      event_type = string
      lambda_qualified_arn = string
    }))
  }))
  default = []
}

# Intent Artifact Repository related variables


variable "intent_Upload_bucket_name" {
  type = string
  description = "S3 Bucket to store intent artifacts"
  default = ""
  validation {
    condition = var.intent_Upload_bucket_name != ""
    error_message = "S3 bucket name required"
  }
}

variable "intent_lambda_function_name" {
  type = string
  description = "Lambda function name"
  default = ""
  validation {
    condition = var.intent_lambda_function_name != ""
    error_message = "Lambda function name required"
  }
}

variable "intent_lambda_handler" {
  type = string
  description = "Lambda function entry point"
  default = "lambda_function.handler"
}

variable "intent_lambda_runtime" {
  type = string
  description = "Runtime config"
  default = "python3.11"
}

variable "intent_lambda_role_arn" {
  type = string
  description = "AWS ARN of IAM Role"
}

variable "logging_is_enabled" {
  type = bool
  description = "S3 logging enabled"
  default = false
}

variable "required_data_tags" {
  description = "Required tags for data at rest as defined by the CCOE Cloud Tagging Requirements"
  type = object({
    BusinessEntity         = string
    ComplianceDataCategory = string
    DataClassification     = string
    DataSubjectArea        = string
    LineOfBusiness         = string
  })
  validation {
    condition     = !contains(["", "<Business Entity>"], var.required_data_tags.BusinessEntity) && !contains(["", "<Compliance Data Category>"], var.required_data_tags.ComplianceDataCategory) && !contains(["", "<Data Classification>"], var.required_data_tags.DataClassification) && !contains(["", "<Data Subject Area>"], var.required_data_tags.DataSubjectArea) && !contains(["", "<Line Of Business>"], var.required_data_tags.LineOfBusiness)
    error_message = "Defining all tags is required for this resource (reference https://confluence.sys.cigna.com/display/CLOUD/Cloud+Tagging+Requirements)."
  }
}

variable "lc_rule_id" {
  description = "Unique name of lifecycle rule"
  type        = string
}

variable "enable_crr" {
  default     = false
  description = "True to enable bucket cross region replication. Defaults to false"
  type        = bool
}

variable "crr_is_enabled" {
  default     = false
  description = "True to enable bucket cross region replication. Defaults to false"
  type        = bool
}

variable "enable_bucket_versioning" {
  default     = true
  description = "Enable versioning on the S3 bucket"
  type        = bool
}

variable "cors_rule_is_enabled" {
  default     = false
  description = "True to enable bucket access logging. Defaults to false"
  type        = bool
}

variable "enable_bucket_keys" {
  default     = false
  description = "True to enable bucket-level key for SSE to reduce the request traffic from Amazon S3 to AWS KMS. Defaults to false"
  type        = bool
}

variable "cors_allowed_origins" {
  default     = ["*"]
  description = "Lifecycle policy rule that governs the transition storage class selected based on number of days. This is used after the first rule is met"
  type        = list
}

variable "cors_allowed_methods" {
  default     = ["GET"]
  description = "Lifecycle policy rule that governs the transition storage class selected based on number of days. This is used after the first rule is met"
  type        = list
}

variable "cors_allowed_headers" {
  default     = ["*"]
  description = "Lifecycle policy rule that governs the transition storage class selected based on number of days. This is used after the first rule is met"
  type        = list
}

variable "use_default_lc_configuration" {
  description = "Set to false if you want to use a custom lifecycle rule configuration for your S3 bucket."
  type = bool
  default = true
}


variable "aws_region_primary" {
  type = string
  default = "us-east-1"
}

variable "aws_primary_accountID" {
  type = string
  default = ""
}

variable "intent_apigw_name" {
  type = string
  default = ""
  validation {
    condition = var.intent_apigw_name != ""
    error_message = "API GW Name is required"
  }
}

variable "intent_apigw_path" {
  type = string
  default = "default"
}

variable "api_gw_deployment_stage" {
  type = list(string)
  default = [ "v1" ]
}

variable "intent_authorizer_lambda_function_name" {
  type = string
  description = "Lambda function name"
  default = ""
  validation {
    condition = var.intent_authorizer_lambda_function_name != ""
    error_message = "Lambda function name required"
  }
}

variable "intent_authorizer_lambda_handler" {
  type = string
  description = "Lambda function entry point"
  default = "lambda_function.handler"
}

variable "apigw_rate_limit" {
  description = "the api rate limit for the deployment"
  default = 100
}

variable "apigw_burst_limit" {
  description = "the api burst limit for the deployment "
  default = 50
}

variable "aws_wafv2_web_acl_name" {
  type = string
  default = "aws_wafv2_web_acl_name"
}

variable "intent-api-web-acl-ip-set-block-rule-name" {
  type = string
  default = "intetn-api-web-acl-ip-set-block-rule-name"
}

variable "intent-api-web-acl-metrics-blocked-request-name" {
  type = string
  default = "intent-api-web-acl-metrics-blocked-request-name"
}

variable "intent-api-web-acl-metrics-allowed-request-name" {
  type = string
  default = "intent-api-web-acl-metrics-allowed-request-name"
}

variable "intent-api-web-acl-black-listed-ipset-name" {
  type = string
  default = "intent-api-web-acl-black-listed-ipset-name"
}

variable "intent-api-web-acl-black-listed-ipset" {
  type = list(string)
  default = []
}

variable "intent-apigw-stage-logging-level" {
  type = string
  default = "ERROR"
}

variable "intent-authinator-principal-arn" {
  type = string
  default = ""
}

variable "intent_apigw_cloudwatch_role_arn" {
  type = string
  default = ""
}

