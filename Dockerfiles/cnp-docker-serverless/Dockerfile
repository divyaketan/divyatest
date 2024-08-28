# you should use cnp-docker-core as your bae image in most cases
# you can also derive from cnp-docker-java, cnp-docker-npm or other
# image created by Software Engineering Excellance
# FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-terraform:0.4.2
# FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-terraform:latest
# FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-terraform:0.3.1
FROM docker-dev.artifactory.express-scripts.com/cnp/cnp-docker-base:latest

ARG GIT_USERNAME
ARG GIT_PASSWORD

LABEL version="0.0.3" \
    name="cnp/cnp-docker-serverless" \
    com.evernorth.cnp.release="0.0.3"\
    com.evernorth.cnp.targets="cbc,orchestrator"\
    com.evernorth.cnp.purpose="Package lambda using cnp-serverless and upload/deploy to AWS using cnp-terraform" \
    maintainer="evernorth/software-engineering-excellence"

#RUN curl -v -o /tmp/aws_corretto.key https://apt.corretto.aws/corretto.key && \
#    apt-key add /tmp/aws_corretto.key && \
#    echo 'deb https://apt.corretto.aws stable main' >> /etc/apt/sources.list.d/amzjava.list

RUN apt-get update -y && \
    apt-get -y install --no-install-recommends \
    cnp-build-serverless-lambda=0.0.3 \
#remove java for now to reduce build time
#    java-1.8.0-amazon-corretto-jdk \
#    java-11-amazon-corretto-jdk \
#    maven 
    && rm -rf /var/lib/apt/lists/* && \
    apt-get clean

COPY settings.xml /usr/share/maven/conf/

# install-jdk-certs.sh does not return status 0 upon success when run in Jenkins. Need '|| true' or similar to force command to exit with status 0

RUN git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@git.express-scripts.com/ExpressScripts/esi-certificates-java /tmp/certs/esi-certificates-java \
&& cd /tmp/certs/esi-certificates-java && ./install-jdk-certs.sh || update-ca-certificates 

