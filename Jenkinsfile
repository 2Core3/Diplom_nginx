pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE_NAME = "nginx"
        DOCKER_REPO = "1core2"
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    def dockerBuildTag = "nginx:v${BUILD_NUMBER}"
                    
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${dockerBuildTag} ."
                }
            }
        }
        
        stage('Tag') {
            steps {
                script {
                    def dockerBuildTag = "nginx:v${BUILD_NUMBER}"
                    def dockerTargetTag = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${dockerBuildTag}"
                    
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${dockerBuildTag} ${dockerTargetTag}"
                }
            }
        }
        
        stage('Push') {
            steps {
                script {
                    def dockerBuildTag = "nginx:v${BUILD_NUMBER}"
                    def dockerTargetTag = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${dockerBuildTag}"
                    
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_HUB_CREDENTIALS')]) {
                        sh "docker login -u 1core2 -p ${DOCKER_HUB_CREDENTIALS}"
                        sh "docker push ${dockerTargetTag}"
                        sh "docker logout"
                    }
                }
            }
        }
    }
}
