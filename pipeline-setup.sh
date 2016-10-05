#!/bin/bash


oc login https://192.168.122.124:8443 --insecure-skip-tls-verify -u openshift-dev -p devel
oc new-project app-dev --display-name="Application Development Environment"
oc new-app --name=ruby-mysql-app https://github.com/tariq-islam/bluegreen#ocp33-pipeline
oc new-app jenkins-ephemeral -p JENKINS_PASSWORD=password
oc create -f https://raw.githubusercontent.com/tariq-islam/bluegreen/ocp33-pipeline/php-bluegreen-app-pipeline-bc.yml
oc new-project app-qa --display-name="Application QA Environment"
oc new-project app-prod --display-name="Application Production Environment"
