# cnp-docker-serverless
This creates the cnp docker image for the cnp-build-serverless-lambda module.

cnp-docker-serverless is the default executor image used by the RxFactor team to deploy python lambdas to AWS. 
This image should be used only by teams using the Express-Scripts CloudCees Core Jenkins environment since it has not been tested on the Cigna AWS cluster.

## Pipeline Modules
cnp-build-serverless-lambda

This pipeline module builds the 'cnp-build-serverless-lambda' module. The source is located under the Modules/ directory.

## CNP Docker File Hierarchy
cnp-docker-serverless currently resides in the cnp docker file hierarchy?

cnp-docker-base
<br>|
<br>|
<br>|&nbsp;&nbsp;&nbsp;cnp-docker-core
<br>&nbsp;&nbsp;&nbsp;|
<br>&nbsp;&nbsp;&nbsp;|
<br>&nbsp;&nbsp;&nbsp;| cnp-docker-serverless