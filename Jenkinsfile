pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE_NAME = "nginx"
        DOCKER_REPO = "1core2"
        DOCKER_BUILD_TAG = "v${BUILD_NUMBER}"
        CONTAINER_IP = credentials('ip_docker')
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    println("BRANCH - ${env.BRANCH_NAME}") 
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
        
        stage('Run') {
            steps {
                script {
                    def dockerTargetTag = "${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_BUILD_TAG}"
                    sh "docker run -d -p 80:80 --name my-image ${dockerTargetTag}"
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    sh "curl ${CONTAINER_IP}:80"
                    def expectedOutput = sh(script: "curl ${CONTAINER_IP}:80", returnStdout: true).trim()
                    def indexHtmlContent = sh(script: "curl ${CONTAINER_IP}:80/index.html", returnStdout: true).trim()
                    
                    if (expectedOutput == indexHtmlContent) {
                        echo "Output matches index.html content"
                    } else {
                        error "Output does not match index.html content"
                    }
                }
            }
        }
        
        stage('Push') {
            when {
                expression { env.BRANCH_NAME == 'main' }
            }
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