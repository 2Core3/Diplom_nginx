pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE_NAME = "nginx"
        DOCKER_REPO = "1core2"
        DOCKER_BUILD_TAG = "v${BUILD_NUMBER}"
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
    }
}
