pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        DOCKER_IMAGE = 'tomcat'
        DOCKER_TAG = "${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
             steps {
                 echo 'Checking out code from the repository'
                 git branch: 'main', url: 'https://github.com/simcampos/tomcat_docker.git'
               }
        }



        stage('Run Container') {
            steps {
                script {
                    echo 'Running Docker container...'
                    sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    sh "docker run -d -p 8082:8080 ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }
}