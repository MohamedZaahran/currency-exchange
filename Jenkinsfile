pipeline {
    agent any
    
    tools {
        maven 'myMaven'
        dockerTool 'myDocker'
    }

    triggers {
        pollSCM('* * * * *')  // This checks the repository every minute
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
        
        stage('Checkout')
        {
            steps {
                echo 'Checking out the SCM...'
                checkout scm
            }
        }

        stage('Build')
        {
            steps {
                script {
                    echo 'Building Maven...'
                    sh 'mvn clean compile'
                }
            }
        }

        stage('Test')
        {
            steps {
                script {
                    echo 'Testing Maven...'
                    sh 'mvn test'
                }
            }
        }

        stage('Package')
        {
            steps {
                script {
                    echo 'Packaging Maven...'
                    sh 'mvn package'
                }
            }
        }

        stage('Build Docker Image')
        {
            steps {
                script {
                    echo 'Building Docker Image...'
                    dockerImage = docker.build("zahran23/currency-exchange:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image')
        {
            steps {
                script {
                    echo 'Pushing Docker Image to DockerHub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Start Minikube')
        {
            steps {
                script {
                    echo 'Starting Minikube...'
                    sh 'minikube start'
                }
            }
        }

        stage('Kubernetes Deploy')
        {
            steps {
                script {
                    sh """
                    kubectl set image deployment/currency-exchange.yaml jenkins-blueocean=zahran23/currency-exchange:${env.BUILD_NUMBER}
                    kubectl rollout status deployment/currency-exchange.yaml
                    """
                }
            }
        }
    }
}