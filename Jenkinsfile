pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        DOCKER_IMAGE          = 'sanusheetal1-blip/trend-app'
        EKS_CLUSTER_NAME      = 'trend-app-cluster'
        AWS_REGION            = 'ap-south-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sanusheetal1-blip/Trend.git'
            }
        }

        stage('Docker Build & Tag') {
            steps {
                script {
                    echo "Building Docker Image version ${BUILD_NUMBER}..."
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Docker Hub Push') {
            steps {
                script {
                    echo "Pushing Docker Image to Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    echo "Updating kubeconfig and deploying to EKS..."
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}"
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                    sh "kubectl rollout status deployment/trend-app"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace and logging out..."
            sh "docker logout || true"
            cleanWs()
        }
    }
}
