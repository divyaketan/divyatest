# CNP-SERVERLESS

This project contains the Python Lambda Uploader Module and the Dockerfiles to build the cnp-docker-serverless image. This project is focused on deploying python lambdas and their dependencies to AWS.

## Goals

The goals of this project is to create a container that can handle serverless deployments to AWS.
* Lambda deployments are zipped up with their dependencies and are uploaded to an S3 bucket and Artifactory
* Deployment of components will be handled by Terraform

## CBC - Jenkins
This bundle is built using CBC - Jenkins. The following job will build the debian package for the PCF module from source.
The job will then create the Container image with the debian package.

[Bundle Job (link to be added later)]()

## Project Documentation
Additional information on this module can be found in the following README(s):
  * [Container Docker Image](Dockerfiles/cnp-docker-serverless/README.md)
  * [Python Lambda Module User Guide](Modules/cnp-build-serverless-lambda/README.md)

## Getting Involved
The goal of this project is to provide as light, clean, simple as possible.
The project is being developed, and contributions are welcome.  Participation is encouraged. if issues or optimizations are identified.

[Module Development Guide](https://confluence.express-scripts.com/display/CNP/Module+Development+Guide)