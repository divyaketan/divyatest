# FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-terraform:0.4.2
# FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-terraform:latest
# FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-terraform:0.3.1
FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-base:latest

LABEL version="0.0.1" \
    name="cnp-build-serverless-lambda-test" \
    com.evernorth.cnp.release="testonly"\
    com.evernorth.cnp.targets="cbc,orchestrator"\
    com.evernorth.cnp.purpose="This is a image that is used for testing the your module. Do not use in builds" \
    maintainer="evernorth/software-engineering-excellance"

#set env vars for local testing
ENV LOCAL_TEST=TRUE
ENV HTTPS_PROXY=http://host.docker.internal:3128
ENV https_proxy=http://host.docker.internal:3128
ENV http_proxy=http://host.docker.internal:3128
ENV HTTP_PROXY=http://host.docker.internal:3128
ENV no_proxy=localhost
ENV NO_PROXY=localhost
ENV LAMBDA_GIT_REPO=https://git.express-scripts.com/ExpressScripts/rxf-pharmacy-processing-all.git
ENV LAMBDA_GIT_BRANCH=develop
ENV SAML2AWS_URL='https://sts.esrx.com/adfs/ls/IdpInitiatedSignOn.aspx'
ENV SAML2AWS_IDP_PROVIDER='ADFS'
ENV SAML2AWS_MFA='Auto'
ENV SAML2AWS_AWS_URN='urn:amazon:webservices'
ENV SAML2AWS_SESSION_DURATION='3600'
ENV SAML2AWS_PROFILE='default'
ENV AWS_DEFAULT_PROFILE='default'
ENV LOG_LEVEL=INFO
ENV CNP_LOG_LEVEL=INFO
ENV ARTIFACTORY_ROOT_URL=https://artifactory.express-scripts.com/artifactory


RUN mkdir -p /fakeJenkinsRoot/target

WORKDIR /fakeJenkinsRoot

RUN curl -o /tmp/aws_corretto.key https://apt.corretto.aws/corretto.key && \
    apt-key add /tmp/aws_corretto.key && \
    echo 'deb https://apt.corretto.aws stable main' >> /etc/apt/sources.list.d/amzjava.list 

# update package references
RUN apt-get update -y && apt -y --no-install-recommends install nano 
    # java-1.8.0-amazon-corretto-jdk \
    # java-11-amazon-corretto-jdk \
    # openjdk-11-jre \
    # openjdk-11-jdk \
    # openjdk-17-jdk \
    # maven

RUN mkdir -p cnp-build-serverless-lambda/cnp-build-serverless-lambda_0.0.1
ADD PACKAGE /fakeJenkinsRoot/cnp-build-serverless-lambda/cnp-build-serverless-lambda_0.0.1

RUN dpkg --build cnp-build-serverless-lambda/cnp-build-serverless-lambda_0.0.1 \
&& apt-get install -y --no-install-recommends ./cnp-build-serverless-lambda/cnp-build-serverless-lambda_0.0.1.deb

#Doesnt work locally as there are no git creds
#RUN git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@git.express-scripts.com/ExpressScripts/esi-certificates-java /tmp/certs/esi-certificates-java && cd /tmp/certs/esi-certificates-java && ./install-jdk-certs.sh || update-ca-certificates 

RUN cd /tmp/esi-certificates-java/ && ./install-jdk-certs.sh || update-ca-certificates

COPY settings.xml /usr/share/maven/conf/ 



# RUN curl -kfsSL ${ARTIFACTORY_ROOT_URL}/generic-local/openjdk/bellsoft-jdk8u272+10-linux-amd64.tar.gz | tar -xzC /usr/lib/jvm/


# RUN Integration Tests
# COPY TestProjects /fakeJenkinsRoot/TestProjects

# ENV PATH="/fakeJenkinsRoot/TestProjects:${PATH}"

# Run tests
# The test argument can be used to disable tests from running during the docker
# build. Tests execute by default so that the Jenkins pipeline can trigger
# tests. For local development, use ./build.sh to run tests either in the build
# or in a container.
# ARG test
# RUN if [ "$test" != "false" ] ; then test.sh ; fi

# to build locally, use build.sh

# running locally with local changes
#docker run --rm -it -v ${PWD}/PACKAGE/usr/local/bin/.:/usr/local/sbin -v ${PWD}/TestProjects:/fakeJenkinsRoot/TestProjects -e PYTHONPATH='/usr/local/sbin/cnp-build-serverless-lambda-scripts' cnp-build-serverless-lambda

# running locally with artifactory image
# docker run --rm -it --mount "type=bind,source=${PWD}/PACKAGE/usr/local/bin,target=/usr/local/bin"  docker-dev.artifactory-dev.express-scripts.com/cnp/cnp-docker-pcf-test:devel