pipeline {
    agent any

    environment {
        DOCKER_REPO = "1core2"
        DOCKER_IMAGE_NAME = "nginx"
        DOCKER_TAG = "v${BUILD_NUMBER}"
        DOCKER_IMAGE = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login --username ${DOCKER_USERNAME} --password-stdin"
                    }
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Push to Docker Repository') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
