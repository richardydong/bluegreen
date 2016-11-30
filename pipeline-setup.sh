#!/bin/bash

echo "Setting up environments and pipeline"

jenkins_image="jenkins-ephemeral"

hostname="https://192.168.122.71:8443"

username="openshift-dev"

repository_path="https://github.com/tariq-islam/bluegreen#ocp33-pipeline-ti"

echo "Logging into OpenShift"
oc login "$hostname" --insecure-skip-tls-verify -u "$username"

echo "Creating shared development environment (app-dev)"
oc new-project app-dev --display-name="Application Development Environment"
oc new-app --name=bluegreen "$repository_path"
oc expose service bluegreen
oc new-app "$jenkins_image" -p JENKINS_PASSWORD=password
oc create -f https://raw.githubusercontent.com/tariq-islam/bluegreen/ocp33-pipeline-ti/php-bluegreen-app-pipeline-bc.yml
oc new-project app-qa --display-name="Application QA Environment"
oc new-project app-prod --display-name="Application Production Environment"
