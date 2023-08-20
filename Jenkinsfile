pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE_NAME = "nginx"
        DOCKER_REPO = "1core2"
        DOCKER_BUILD_TAG = "v${BUILD_NUMBER}"
        CONTAINER_IP = "172.31.0.2"
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    def dockerBuildTag = "${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG}"
                    sh "docker build -t ${dockerBuildTag} ."
                }
            }
        }
        
        stage('Tag') {
            steps {
                script {
                    def dockerTargetTag = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG} ${dockerTargetTag}"
                }
            }
        }
        
        stage('Push') {
            steps {
                script {
                    def dockerTargetTag = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG}"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh "docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD"
                        sh "docker push ${dockerTargetTag}"
                        sh "docker logout"
                    }
                }
            }
        }
        
        stage('Run') {
            steps {
                script {
                    def dockerTargetTag = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG}"
                    sh "docker run -d -p 80:80 --name my-image ${dockerTargetTag} gunicorn --bind 0.0.0.0:80 src.core.wsgi:app"
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    sh "curl ${CONTAINER_IP}:80"
                }
            }
        }
        
        stage('Clean') {
            steps {
                script {
                    sh "docker stop my-image"
                    sh "docker rm my-image"
                }
            }
        }
    }
    
    post {
        failure {
            sh "docker stop my-image"
            sh "docker rm my-image"
        }
        always {
            sh "docker image rm ${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG}"
        }
    }
}
