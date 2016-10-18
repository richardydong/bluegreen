# What This Is For?
With integrated pipelines being a great new feature (albeit in tech preview status currently) released with OpenShift 3.3, I wanted to put together an easy way for folks to try it out beyond the simplistic example that's included OOTB. This example takes a php application and promotes dev builds across multiple environments automatically, while also asking the user for approval input before deploying into each higher level environment. The flow is as follows:

> 1. Execute the build pipeline
> 2. A new build and deploy executes in the dev environment
> 3. The pipeline asks for approval prior to promoting to QA
> 4. The pipeline deploys to the QA environment upon approval
> 5. The pipeline asks for approval prior to promoting to Production
> 6. The pipeline deploys to the Production environment upon approval

In order to use this example, you just need an OpenShift instance and the oc client tool.
<br>
> As a side note, I'm working on parameterizing this more so that the following isn't as tedious.
<br>

# How To Set This Up In Your Own Repository
+ You need internet connectivity for this... I'm working on making this completely offline, so more to come there.
+ __Fork this specific repo branch (ocp33-pipeline)!__ You'll want to be able to make code changes and roll them out across environments. The pipeline expects the app to be called 'bluegreen' for now. I'm hoping to parameterize this as well soon.
+ __Edit and commit__ the bluegreen-pipeline-bc.yml file so that the git uri on line 10 points to your fork. Also update the 'ref' (branch) stanza as necessary. 
+ __Edit and commit__ the pipeline-setup.sh file so that it points to your php-bluegreen-app-pipeline-bc.yml file on line 36. 
+ __Edit and commit__ your Jenkinsfile and update line 23 with your OCP hostname / ip address as well as the appropriate username and password for logging into OpenShift. It assumes openshift-dev/devel right now. 
+ Clone your repository locally ... note in the example below I'm cloning my branch. If you've forked my branch into your master, you can leave the -b flag out.

```
git clone https://github.com/tariq-islam/bluegreen -b ocp33-pipeline
```

# Next Up...

+ Run the pipeline-setup.sh script (don't forget to change permissions on the file to make it executable)

```
./pipeline-setup.sh
```

+ Check your OpenShift environment. The script should have set up three projects for you (App Dev, App QA, and App Production).
+ Check out the Overview for the App Dev project, the script should have provisioned the following:
	+ A Jenkins (ephemeral) instance (credentials are _admin/password_)
	+ An initial deployment of your fork of the bluegreen php application

+ Click on _Builds --> Pipelines_, and you should see a pipeline already configured. Feel free to look through its configuration and note that it's pointing to the Jenkinsfile that's part of your repository.
+ Click on _Start Pipeline_ at the top right of the _Pipelines_ screen. The pipeline will begin to run and will walk you through the workflow as described above, asking for input/approval where necessary.

> One point of caution -- be sure that the Development build completes and the image is pushed into the repository _before_ you approve a deployment into QA or Prod. If you approve into QA or Prod before the newly built image is pushed into the registry from Dev, you'll end up with a bit of a race condition where QA and Prod simply redeploy the now older image.

Once you're all finished, you can run the **cleanup.sh** script to remove everything.

```
./cleanup.sh
```
