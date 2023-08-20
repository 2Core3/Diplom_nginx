pipeline {
    agent any

    stages {
        stage('Check Files') {
            steps {
                script {
                    def requiredFiles = ['Dockerfile', 'index.html', 'script_dockerhub.sh', 'test.sh']
                    def missingFiles = []

                    for (file in requiredFiles) {
                        if (!fileExists(file)) {
                            missingFiles.add(file)
                        }
                    }

                    if (!missingFiles.isEmpty()) {
                        error "Missing required files: ${missingFiles.join(', ')}"
                    }
                }
            }
        }

        stage('Run DockerHub Script') {
            steps {
                script {
                    def scriptOutput = sh(script: './script_dockerhub.sh', returnStatus: true).trim()
                    if (scriptOutput != 'ok') {
                        error "Script script_dockerhub.sh failed with output: ${scriptOutput}"
                    }
                }
            }
        }

        stage('Run Test Script') {
            steps {
                sh './test.sh'
            }
        }

        stage('Build and Deploy Docker Image') {
            steps {
                script {
                    def version = sh(script: 'echo $BUILD_NUMBER', returnStdout: true).trim()
                    def imageName = "my-nginx:v${version}"

                    sh "docker build -t ${imageName} ."
                    sh "docker save -o ${imageName}.tar ${imageName}"
                    sshagent(credentials: ['vagrant-ssh-credentials-id']) {
                        sh "scp -o StrictHostKeyChecking=no ${imageName}.tar vagrant@192.168.56.106:/home/vagrant/"
                        sh "sshpass -p 'vagrant' ssh vagrant@192.168.56.106 'docker load -i /home/vagrant/${imageName}.tar'"
                    }
                }
            }
        }
    }
}
