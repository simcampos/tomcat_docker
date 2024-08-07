pipeline {
    agent any


    environment {
            DOCKER_IMAGE = "tomcat_docker:v1"
            GIT_REPO = "https://github.com/simcampos/tomcat_docker.git"
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
                    // Build the Docker image using the provided Dockerfile
                    def app = docker.build("${env.DOCKER_IMAGE}", ".")
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    echo 'Running Docker container...'
                    docker.image("${env.DOCKER_IMAGE}").inside {
                        sh 'docker run -d -p 8080:8080 ${env.DOCKER_IMAGE}'
                }
            }
        }
    }

    post {
            always {
                // Clean up after the build
                cleanWs()
            }
        }
}