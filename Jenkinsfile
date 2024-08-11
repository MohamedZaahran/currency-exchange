pipeline {
    agent any
    
    environment {
        SonarQubeHome = tool "mySonarQube"
    }

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
                    sh 'sonar-scanner --version'
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    script {
                        sh 'sonar-scanner -Dsonar.host.url=http://sonarqube:9000'
                    }
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
                    echo 'Deploying on Kubernetes...'
                    sh 'envsubst < currency-exchange.yaml | kubectl apply -f -'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying Deployment...'
                    sh '''
                    kubectl rollout status deployment/currency-exchange-deployment
                    kubectl get pods -l app=currency-exchange
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Finished.'
            //cleanWs()
        }
        success {
            echo 'Succeeded.'
        }
        failure {
            echo 'Failed.'
        }
    }
}