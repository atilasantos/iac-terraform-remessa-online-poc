// Jenkinsfile
String credentialsId = 'awsCredentials'(

def setAwsCredentials() {
  withCredentials([[
    $class: 'AmazonWebServicesCredentialsBinding',
    credentialsId: credentialsId,
    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    ]])
}

try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }

  // Run terraform init
  stage('Initializing Terraform!') {
    node {
      sh 'terraform --version'
      setAwsCredentials(){
        ansiColor('xterm') {
          sh 'terraform init'
        }
      }
    }
  }

  // Run terraform plan
  stage('Planning terraform execution') {
    node {
     setAwsCredentials() {
        ansiColor('xterm') {
          sh 'terraform plan'
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master') {

    // Run terraform apply
    stage('apply') {
      node {
        setAwsCredentials() {
          ansiColor('xterm') {
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    // Run terraform show
    stage('show') {
      node {
       setAwsCredentials() {
          ansiColor('xterm') {
            sh 'terraform show'
          }
        }
      }
    }
  }
  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
  }
}