pipeline {
    environment {
        docker = tool 'myDocker'
        maven = tool 'myMaven'
        PATH = "${docker}/bin:${maven}/bin:${PATH}"
    }

    agent any
    
    stages {
        stage('Environment Setup')
        {
            steps {
                script {
                    echo 'Verifying Envionment Setup...'
                    sh 'mvn --version'
                    sh 'docker --version'
                }
            }
        }
    }
}