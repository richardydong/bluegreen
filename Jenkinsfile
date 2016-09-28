node {
  stage 'Build and Deploy image to Dev'
  echo 'Deploying image to Dev'
  appDeploy()
}

// Deploy the project based on a existing ImageStream
def appDeploy(){
    sh "oc new-app https://github.com/tariq-islam/bluegreen.git#ocp33-pipeline || oc start-build bluegreen"
    sh "oc expose service bluegreen || echo 'Service already exposed'"
}
