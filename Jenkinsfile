// Jenkinsfile
String credentialsId = 'awsCredentials'

def commitMessage;


try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }
  
  // Run terraform init
  stage('Initializing terraform..') {
    node {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: credentialsId,
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh '/tmp/terraform init'
        }
      }
    }
  }

  stage('Validating wether destroy or apply..') {
    commitMessage = sh(script: "git log -1 --pretty=format:'%B'", returnStdout: true)
    if(commitMessage.contains('#destroy')) {
      ansiColor('xterm') {
        sh '/tmp/terraform destroy -auto-approve'
        currentBuild.result = 'SUCCESS'
        return
      } else {
        echo "Let's go apply!"
      }
    }
  }

  // Run terraform plan
  stage('Planning to execute terraform..') {
    node {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: credentialsId,
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh '/tmp/terraform plan'
        }
      }
    }
  }

  echo env.BRANCH_NAME
  if (env.BRANCH_NAME == 'main') {

    // Run terraform apply
    stage('Applying changes!') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentialsId,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh '/tmp/terraform apply -auto-approve'
          }
        }
      }
    }

    // Run terraform show
    stage('show') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentialsId,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh '/tmp/terraform show'
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
