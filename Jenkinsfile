pipeline {
    agent any

    tools {
        docker 'myDocker'
        maven 'myMaven'
    }

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