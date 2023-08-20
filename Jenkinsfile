pipeline {
    agent any
    stages {
        stage('Check Files') {
            steps {
                script {
                    def requiredFiles = ['Dockerfile', 'index.html', 'script_dockerhub.sh', 'test.sh']
                    for (file in requiredFiles) {
                        if (!fileExists(file)) {
                            error("Required file not found: ${file}")
                        }
                    }
                }
            }
        }
        
        stage('Docker Hub Script') {
            steps {
                script {
                    def result = sh(script: './script_dockerhub.sh', returnStatus: true)
                    if (result != 0) {
                        error("Docker Hub script failed.")
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    def result = sh(script: './test.sh', returnStatus: true)
                    if (result != 0) {
                        error("Tests failed.")
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def version = sh(script: 'echo ${BUILD_NUMBER}', returnStdout: true).trim()
                    sh(script: "docker build -t my-nginx:v${version} .")
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    sh(script: "docker run -d -p 80:80 my-nginx:v${BUILD_NUMBER}")
                    sleep(time: 10, unit: 'SECONDS')  // Wait for container to start
                }
            }
        }
        
        stage('Push Image') {
            steps {
                script {
                    sh(script: "./push.sh my-nginx:v${BUILD_NUMBER}")
                }
            }
        }
    }
}
