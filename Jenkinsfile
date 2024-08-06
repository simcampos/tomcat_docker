pipeline {
    agent any

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

                    sh "docker build -t tomcat:v1 ."
                    sh "docker run -p 8082:8080 tomcat:v1"
                }
            }
        }
    }
}