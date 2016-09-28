node {
  stage 'Build image in Dev'
  echo 'Building docker image and deploying to Dev'
  buildApp('helloworld-msa-dev')
    
  stage 'Deploy image to Dev'
  echo 'Deploying image to Dev'
  appDeploy()
}

// Creates a Build and triggers it
def buildApp(String project){
    sh "oc project ${project}"
    sh "oc new-build --name=bluegreen -l app=bluegreen || echo 'Build exists'"
    sh "oc start-build bluegreen --from-dir=. --follow"
}

// Deploy the project based on a existing ImageStream
def appDeploy(){
    sh "oc new-app bluegreen -l app=bluegreen || echo 'Aplication already Exists'"
    sh "oc expose service bluegreen || echo 'Service already exposed'"
}
