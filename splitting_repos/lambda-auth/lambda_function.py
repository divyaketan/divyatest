import logging

def authorize(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    
    logging.debug(event)
    logging.debug(context)

    response = {
        # The principal user identification associated with the token sent by
        # the client.
        "principalId": "*",
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [{
                "Action": "execute-api:Invoke",
                "Effect": "Deny",
                "Resource": event["methodArn"]
            }]
        }
    }

    try:
        if (event["authorizationToken"] == "intentapi.artifacts.upload"):
            response = {
                # The principal user identification associated with the token
                # sent by the client.
                "principalId": "*",
                "policyDocument": {
                    "Version": "2012-10-17",
                    "Statement": [{
                        "Action": "execute-api:Invoke",
                        "Effect": "Allow",
                        "Resource": event["methodArn"]
                    }]
                }
            }
            print('allowed')
            return response
        else:
            print('denied')
            return response
    except BaseException:
        print('denied')
    logging.debug(response)
    return response