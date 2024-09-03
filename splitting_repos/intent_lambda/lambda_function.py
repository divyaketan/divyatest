import logging
import boto3
import json
import base64
from botocore.config import Config


def create_presigned_url(event, context):
    """Generate a presigned URL to share an S3 object
    :param bucket_name: string
    :param object_name: string
    :param expiration: Time in seconds for the presigned URL to remain valid
    :return: Presigned URL as string. If error, returns None.
    :JSON Structure to invoke the API 
    {
        "bucket_name": "intents-artifacts-364685145795",
        "object_name": "response.txt",
        "expiration": "3600",
        "request_type": "<operation*>"
    }

    <operation*> = put_object/get_object
    """
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    logging.debug(event)
    
    request_body = ''
    
    if (event['body']) and (event['body'] is not None):
        is_decoded = event['isBase64Encoded']
        if (is_decoded):
            encoded_body = event['body']
            request_body = json.loads(base64.b64decode(encoded_body))
        else:
            request_body = json.loads(event['body'])
    else:
        return None

    logging.debug(request_body)
    # Generate a presigned URL for the S3 object
    s3_client = boto3.client('s3', config=Config(signature_version='s3v4'))
    try:
        # request_body['request_type'] valid values = put_object or get_object
        response = s3_client.generate_presigned_url(request_body['request_type'],
                                                    Params={'Bucket': request_body['bucket_name'],
                                                            'Key': request_body['object_name']},
                                                            ExpiresIn=request_body['expiration'])
        response_body = response
        response_body = base64.b64encode(response_body.encode())
        response = {
            "isBase64Encoded" : "true", 
            "statusCode": "200", 
            "headers": {
                "content-type":"application/json"
            },
            "body": response_body.decode()
        }
    except Exception as e:
        logging.error(e)
        response = {
            "isBase64Encoded" : "false", 
            "statusCode": "500", 
            "headers": {
                "content-type":"application/json"
            },
            "body": "Unexpected exception, please check lambda"
        }
        
    logging.debug(json.dumps(response))
    # The response contains the presigned URL
    return response
    