#!/bin/bash

source cnp-util-core-error-handler.sh

if [ -z "$awsUsername" ]; then
  set_error $moduleName "No username provided to login script"
fi

if [ -z "$CNP_BUILD_SERVERLESS_LAMBDA_AWS_MODULE_TOKEN" ]; then
  set_error $moduleName "No password provided to login script"
fi

echo ""
echo "Logging into AWS..."
  export SAML2AWS_URL='https://sts.esrx.com/adfs/ls/IdpInitiatedSignOn.aspx'
  export SAML2AWS_IDP_PROVIDER='ADFS'
  export SAML2AWS_MFA='Auto'
  export SAML2AWS_AWS_URN='urn:amazon:webservices'
  export SAML2AWS_SESSION_DURATION='3600'
  export SAML2AWS_PROFILE='default'
  export AWS_DEFAULT_PROFILE='default'
  if [[ ${awsUsername} =~ ^.*\\.* ]]; then
    export SAML2AWS_USERNAME="${awsUsername}"
  else
    export SAML2AWS_USERNAME="accounts\\${awsUsername}"
  fi

  export SAML2AWS_PASSWORD=$CNP_BUILD_SERVERLESS_LAMBDA_AWS_MODULE_TOKEN
  export SAML2AWS_ROLE="arn:aws:iam::${awsAccountId}:role/${awsRoleName}"

  saml2aws login --force --skip-prompt
  check_status $moduleName $? "saml2aws login"
