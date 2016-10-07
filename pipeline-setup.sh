#!/bin/bash

echo "Please enter your OpenShift hostname:port (https://<hostname>:<port>): "

read hostname

echo "Enter your username: "

read username

# Uncomment the following line and specify your master:port to log into if you want to automate the login and not have to login prior to running this script
oc login "$hostname" --insecure-skip-tls-verify -u "$username"
oc new-project app-dev --display-name="Application Development Environment"
oc new-app --name=bluegreen https://github.com/tariq-islam/bluegreen#ocp33-pipeline
oc expose service bluegreen
oc new-app jenkins-ephemeral -p JENKINS_PASSWORD=password
oc create -f https://raw.githubusercontent.com/tariq-islam/bluegreen/ocp33-pipeline/php-bluegreen-app-pipeline-bc.yml
oc new-project app-qa --display-name="Application QA Environment"
oc new-project app-prod --display-name="Application Production Environment"
