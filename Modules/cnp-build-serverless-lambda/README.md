# cnp-build-serverless-lambda
Cloud Native Pipeline module for zipping up a python3.9 lambda or lambda layer.

## Pipeline Usage
To use this module in your pipeline you must register the module in your Jenkins file and then call the build() function with the required arguments. Output will be a lambda.zip file in the ./terraform directory. Deployment can be done by cnp-terraform container/module after if needed in a later step.

~~~groovy
@Library('Cloud_Native_Pipeline') _
def lambdaImage ="docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-serverless:0.0.3"

def modules  = [
    [contractName: "BUILD",
    commandName:"cnp-build-serverless-lambda.sh",
    subCommand:"build",
    [id: env.ARTIFACTORY_CREDENTIAL, prefix: 'ARTIFACTORY']],
    image: lambdaImage],

cnpNode(modules) {
    checkoutFromScm()

    build([
        artifactoryArchivePath: "ci-snapshot-local/test/test", # NOT USED YET
        lambdaLanguage: "python",
        filesToRemoveFromZip: "CODEOWNERS;Jenkinsfile;README.md;.gitignore;releaseInfo.json",
        directoriesToRemoveFromZip: ".git;terraform"
        ])

~~~

### Supported Arguments
This table shows all the arguments

| Property                                 |Required          | Property Description                                                                                                                             | Default Value                        | Supported Options                                                                                                                      |
|------------------------------------------|------------------------------------------------------------------------------------------------------------------------|--------------------------------------|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| artifactoryArchivePath (not in use yet)  | No  |Path for zip bundle to be uploaded to in Artifactory  | none | ci-snapshot-local/.../... |
| lambdaLanguage                           | Yes |Language for Lambda  | none | 'python' |
| filesToRemoveFromZip                     | No  |Semicolon seperated list of files to remove from the final zip   | none | 'CODEOWNERS;Jenkinsfile;README.md;.gitignore' |
| directoriesToRemoveFromZip               | No  |Semicolon seperated list of directories to remove from the final zip  | none | '.git;terraform' |


## Conventions
* A requirements.txt for pip dependencies is required in the root of the lambda folder if any dependencies are needed for the lambda to run.
* Lambda repo example: https://git.express-scripts.com/ExpressScripts/aws-rxf-nrx-service
* Lambda layer repo example: https://git.express-scripts.com/ExpressScripts/aws-rxf-python-common


### General repo layout:
~~~
requirements.txt
lambda_function.py
additional_python_code.py
└── terraform/
    lambda.tf
    other_terraform_plans.tf
    └── envs/
        └── dev
            └── dev.tfvars
            └── backend.config
        └── qa
            └── qa.tfvars
            └── backend.config
        └── prod
            └── prod.tfvars
            └── backend.config

~~~


## Deploy Criteria
For a successful deployment, please adhere to the following conditions:

* All required parameters are set
* One single lambda in the repo
* There is a requirements.txt if dependencies are needed from pip
* Terraform plans located in the terraform directory in the root of the repo

## Build Images
Currently, this module is not installed in any of the default build images.
However, it's parent build image is located in the following github
* [cnp-docker-serverless](https://git.express-scripts.com/kubernetes/cnp-serverless)