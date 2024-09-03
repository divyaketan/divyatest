terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

# used to get the account id
data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "mongo_like_table" {
  name           = "mongo-like-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"  
    }
    tags = {
    Name = "MongoLikeTable"
    }
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
      Service = "lambda.amazonaws.com"
}
}
]
})
}
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_lambda_function" "create_item" {
  filename         = "lambda_function_payload.zip" # Path to your Lambda function zip file
  function_name    = "CreateItemFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8" # Adjust runtime as needed
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
environment {
  variables = {
    TABLE_NAME = aws_dynamodb_table.mongo_like_table.name
  }
} 
}
resource "aws_api_gateway_rest_api" "api" {
  name        = "MongoLikeAPI"
  description = "API for creating items in Mongo-like DynamoDB table"
}
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "items"
}
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_item.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}//"
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.create_item.invoke_arn
}
