@Library('Cloud_Native_Pipeline') _

import com.evernorth.cloudnativebuild.data.PipelineConstants

def k8sImage="cnp/cnp-docker-k8s:latest"
def coreImage="cnp/cnp-docker-core:latest"
def modules  = [
   [contractName: "PACKAGE",  commandName:"cnp-package-deb.sh", subCommand:"create-many", image: coreImage, credentials: [[id: env.ARTIFACTORY_CREDENTIAL]]],
   [contractName: "CONTAINER",  commandName:"cnp-build-package-docker.sh", subCommand:"create", image: k8sImage, credentials: [[id: env.ARTIFACTORY_CREDENTIAL]]],
   [contractName: "RELEASE", commandName:"cnp-release-xlr.sh", subCommand:"releaseImage", 
   credentials: [[id: "xlRelease"], [id: env.GIT_CREDENTIAL, prefix: 'GIT'], [id: env.ARTIFACTORY_CREDENTIAL, prefix: 'ARTIFACTORY']],
   image: k8sImage, allowPipelineToModifyArgumentList: true, requiresUnStash: true, unStashName: "source-stash", artifactType: PipelineConstants.ARTIFACT_TYPE_CONTAINER]
]

cnpNode (modules) {
    checkoutFromScm()

    createPackages([packageRoot: "Modules"])

    withCredentials([[$class: 'UsernamePasswordMultiBinding',
        credentialsId: env.GIT_CREDENTIAL,
        passwordVariable: 'GIT_PASSWORD',
        usernameVariable: 'GIT_USERNAME']]) {

        createContainer(
                [
                contextPath: "Dockerfiles/cnp-docker-serverless",
                latest     : true,
                dockerBuildArgs  : "GIT_USERNAME=${GIT_USERNAME} GIT_PASSWORD=${GIT_PASSWORD}"
                ])
        }
    awaitApproval([approvers: 'en5426', time: 120, unit: 'MINUTES', message: 'Do you want to continue with release?'])
    release([touchless:true], {})
}
