node {
  // Jenkinsfile
  String credentialsId = 'awsCredentials'

  stage('Pipeline iniciado') {
    withCredentials([[
      $class: 'AmazonWebServicesCredentialsBinding',
      credentialsId: credentialsId,
      accessKeyVariable: 'AWS_ACCESS_KEY_ID',
      secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]])

    try {
    stage('Checkout into main branch') {
        cleanWs()
        checkout scm
    }
    
    // Run terraform init
    stage('Initializing terraform..') {
      ansiColor('xterm') {
        sh '/tmp/terraform init'
      }
    }

    //Check why a boolean variable wasn't working
    if(env.DESTROY == 'Sim') {
      stage('Initializing destroy.') {
          ansiColor('xterm') {
            sh '/tmp/terraform destroy -auto-approve'
            currentBuild.result = 'SUCCESS'
          }
      }
      return
    }
    

    // Run terraform plan
    stage('Planning to execute terraform..') {
        ansiColor('xterm') {
          sh '/tmp/terraform plan'
        }
    }

    echo env.BRANCH_NAME
    if (env.BRANCH_NAME == 'main') {

      // Run terraform apply
      stage('Applying changes!') {
          ansiColor('xterm') {
            sh '/tmp/terraform apply -auto-approve'
          }
      }

      // Run terraform show
      stage('show') {
          ansiColor('xterm') {
            sh '/tmp/terraform show'
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
  }
}