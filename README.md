# Automated CI/CD Pipeline with Docker, Jenkins, and Kubernetes
This repository contains a fully automated Continuous Integration/Continuous Deployment (CI/CD) pipeline designed to streamline the development, testing, and deployment process of a Java-based microservice. The pipeline is built using Jenkins, Docker, and Kubernetes, enabling seamless integration and deployment from code commit to production.

![Workflow](https://github.com/user-attachments/assets/6b3e9b6b-dd67-42c7-a7c5-311f9e4e774a)

## Key Features:
### Jenkins Pipeline Automation:
The Jenkins pipeline is triggered by **SCM polling**, ensuring that the pipeline runs every time there's a new commit in the source code repository.<br>
Automated stages for building, testing, packaging, and deploying the application using Jenkins, providing clear feedback at every step of the process.

![Jenkins Pipeline](https://github.com/user-attachments/assets/158ecb3d-e967-48d5-a0fc-71255c5d7eb6)

### Docker Integration:
The application is packaged as a Docker image, ensuring consistent environments across development, testing, and production.<br>
The pipeline builds the Docker image using Maven, tags it with the build number, and pushes it to **Docker Hub**.

### Docker Image Scanning with Trivy:
To ensure the security of the Docker images, the pipeline uses **Trivy** to scan the built Docker image for vulnerabilities.<br>
Trivy scans the image and reports any vulnerabilities, especially those with HIGH or CRITICAL severity, before pushing the image to Docker Hub.

### SonarQube Code Analysis:
The pipeline integrates **SonarQube** for static code analysis, ensuring that the code meets quality standards before being deployed.<br>
SonarQube analyzes the code, identifies potential bugs, code smells, and security vulnerabilities, and reports them within the pipeline.

![SonarQube Analysis](https://github.com/user-attachments/assets/8ac324be-9098-4f00-a815-75bd84c1e806)

### Kubernetes Deployment:
The Docker image is deployed to a **Kubernetes cluster** running on **Minikube**, using a **Kubernetes Deployment** and **Service** definition.<br>
The pipeline includes a verification stage to ensure that the application is successfully deployed and running in the Kubernetes cluster.

### Environment Setup and Verification:
Initial stages in the pipeline verify the environment setup, including Maven and Docker versions, ensuring that the necessary tools are in place before proceeding with the build.<br>
The pipeline automatically starts Minikube if it's not already running.

## How It Works:

1. **SCM Polling:** Jenkins polls the SCM repository for changes every minute.<br>
2. **Environment Setup:** Jenkins verifies that the required tools (Maven, Docker) are installed.<br>
3. **Build & Test:** The application is built, tested, and packaged using Maven.<br>
4. **SonarQube Analysis:** The source code is analyzed for quality and security issues using SonarQube.<br>
5. **Docker Image Creation:** The packaged application is built into a Docker image, tagged, and pushed to Docker Hub.<br>
6. **Trivy Docker Image Scanning:** The Docker image is scanned for vulnerabilities using Trivy.<br>
7. **Kubernetes Deployment:** The Docker image is deployed to a Kubernetes cluster using Minikube.<br>
8. **Deployment Verification:** The pipeline verifies that the application is successfully deployed and running in the Kubernetes cluster.
<br>
This setup ensures a robust and automated process for continuous integration and deployment, reducing manual intervention and minimizing the risk of errors in the deployment process.
<br>

## Technologies Used:

- **Jenkins:** For automating the CI/CD pipeline.<br>
- **Docker:** For containerizing the application.<br>
- **Kubernetes:** For orchestrating the deployment and management of the containerized application.<br>
- **Maven:** For building, testing, and packaging the Java application.
- **SonarQube:** For static code analysis to ensure code quality.<br>
- **Trivy:** For scanning Docker images for vulnerabilities.
