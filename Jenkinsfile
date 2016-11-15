node {
    stage 'Build image and deploy in Dev'
    echo 'Building docker image and deploying to Dev'
    buildApp('app-dev')

	stage 'Run integration testing'
	echo 'Running integration tests'

    stage 'Deploy to QA'
    echo 'Deploying to QA'
    deployApp('app-dev', 'app-qa')

    stage 'Deploy to production'
    echo 'Deploying to production'
    deployApp('app-dev', 'app-prod')
}

// Creates a Build and triggers it
def buildApp(String project){
    sh "oc login https://192.168.122.71:8443 --insecure-skip-tls-verify -u openshift-dev -p devel"
	sh "oc project ${project}"
    sh "oc start-build bluegreen"
}

// Tag the ImageStream from an original project to force a deployment
def deployApp(String origProject, String project){
    sh "oc project ${project}"
    sh "oc policy add-role-to-user system:image-puller system:serviceaccount:${project}:default -n ${origProject}"
    sh "oc tag ${origProject}/bluegreen:latest ${project}/bluegreen:latest"
    appDeploy()
}

// Deploy the project based on an existing ImageStream
def appDeploy(){
    sh "oc new-app bluegreen || echo 'Application already exists'"
    sh "oc expose service bluegreen || echo 'Service already exposed'"
}
