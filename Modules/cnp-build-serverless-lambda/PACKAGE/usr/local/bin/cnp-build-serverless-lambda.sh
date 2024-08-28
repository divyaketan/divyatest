#!/bin/bash

################
# cnp-build-serverless-lambda.sh
# This is a module for the Evernorth Cloud Native Pipeline.
# It will deploy an application to the on-premise Pivotal Cloud Foundry (PCF).  It effectively serves as a replacement
# for PCF deployments from the CBC Jenkins-Pipeline.
################
apt show cnp-build-serverless-lambda
echo -e "\n"
moduleName="cnp-build-serverless-lambda"

echo "======================================================="
pwd
ls -lah
echo "======================================================="

source cnp-build-serverless-lambda-functions.sh
source cnp-util-core-error-handler.sh

supportedVariables=("gitRepoURL" "gitBranch" "lambdasPath" "artifactoryArchivePath" "filesToRemoveFromZip" "directoriesToRemoveFromZip")
. cnp-util-core-input-parser.sh "$2" "${supportedVariables[@]}"

# export awsAccountId
# export awsRoleName
# export awsUsername

# if [ -z $LOCAL_TEST ]
# then
#     . cnp-build-serverless-lambda-aws-login.sh
# fi



main "$1" "$2"


check_status $moduleName $? 'cnp-build-serverless-lambda'

generate_output $moduleName