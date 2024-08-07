pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "tomcat_docker"
        GIT_REPO = "https://github.com/simcampos/tomcat_docker.git"
        DOCKER_TAG = "${env.BUILD_ID}"
    }

    stages {
        stage('clone repository') {
           steps {
                echo 'Checking out code from the repository'
                git branch: 'main', url: "${env.GIT_REPO}"

                }
            }


        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", ".")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run -d -p 8082:8080 ${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
