pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "tomcat_docker:v1"
        GIT_REPO = "https://github.com/simcampos/tomcat_docker.git"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the GitHub repository
                git url: "${env.GIT_REPO}"
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

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container
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
