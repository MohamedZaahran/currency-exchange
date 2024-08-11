pipeline {
    agent any
    
    environment {
        SonarQubeHome = tool "mySonarQube"
        JAVA_HOME = "${tool 'java17'}"
        PATH = "${env.JAVA_HOME}/bin:${SonarQubeHome}/bin:${PATH}"
    }

    tools {
        jdk 'java17'
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
            tools {
                jdk "jdk17" // the name you have given the JDK installation using the JDK manager (Global Tool Configuration)
            }
            environment {
                scannerHome = tool 'SonarQube Scanner' // the name you have given the Sonar Scanner (Global Tool Configuration)
            }
            steps {
                echo 'Analysing code with SonarQube...'
                withSonarQubeEnv('My SonarQube Server') {
                    sh 'sonar-scanner -Dsonar.host.url=http://sonarqube:9000'
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