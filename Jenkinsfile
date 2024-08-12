pipeline {
    agent any
    
    environment {
        SonarQubeHome = tool "mySonarQube"
        PATH = "${SonarQubeHome}/bin:${PATH}"
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
                echo 'Analysing code with SonarQube...'

                withSonarQubeEnv('My SonarQube Server') {
                    script {
                        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                            sh """
                            sonar-scanner \
                            -Dsonar.host.url=http://sonarqube:9000 \
                            -Dsonar.login=${SONAR_TOKEN} \
                            -Dsonar.projectKey=currency-exchange \
                            -Dsonar.projectName=currency-exchange \
                            -Dsonar.sources=. \
                            -Dsonar.java.binaries=target/classes
                            """
                        }
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

        stage('Scan Docker Image with Trivy') {
            steps {
                script {
                    echo 'Scanning Docker Image with Trivy...'
                    sh 'trivy image --severity HIGH,CRITICAL zahran23/currency-exchange:${env.BUILD_NUMBER}'
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