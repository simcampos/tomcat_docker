This project needs the war files on same folder as the dockerfile.
The docker file:
``` dockerfile
FROM tomcat:10.0.0-M7-jdk11-openjdk-slim

COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
COPY context.xml /tmp/context.xml
#this next two are for https
COPY localhost.key /usr/local/tomcat/conf/localhost.key
COPY localhost.pem /usr/local/tomcat/conf/localhost.pem

#alternative to https
#COPY keystore.jks /usr/local/tomcat/conf/keystore.jks

COPY server.xml /usr/local/tomcat/conf/server.xml

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps2; mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps; cp /tmp/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml;

ADD sample.war /usr/local/tomcat/webapps/
ADD sampleLogin.war /usr/local/tomcat/webapps/

EXPOSE 8080
EXPOSE 8443

CMD ["catalina.sh", "run"]
```

comnands to run the docker:
``` docker build -t tomcat:v1 .    ```
``` docker run -d -p 8082:8080 tomcat:v1  ```

Command to explore running docker:
``` docker exec -it [CONTAINER ID] /bin/bash  ```

To copy server.xml file from docker to local machine an edit it:
```  docker cp [CONTAINER ID]:/usr/local/tomcat/conf/server.xml .  ```
docker cp bb889a7d7021:/usr/local/tomcat/conf/server.xml .

Command to install nano inside docker:
```
apt-get update && apt-get install -y nano
```

Inside java program files, command to create a keystore file:
```  cmd
keytool -genkey -alias tomcat -keyalg RSA -keystore C:\Users\simao\Documents\Projects\tomcat_docker\conf\localhost.jks -keysize 2048 
```

To create a keystore file to use with tomcat using openssl:
``` bash
openssl req -x509 -newkey rsa:2048 -keyout localhost.key -out localhost.pem -days 365 -nodes
```

Scrite to add to server.xml file to enable https:
``` xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="150"
           scheme="https"
           secure="true"
           SSLEnabled="true"
           sslProtocol="TLS"
           clientAuth="false"
           maxParameterCount="1000">
    <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol" />
    <SSLHostConfig>
        <Certificate	certificateKeyFile="conf/localhost.key"
                      certificateFile="conf/localhost.pem"
                      type="RSA" />
    </SSLHostConfig>
</Connector>
````

To automate the deployment of the docker container, we used a jenkins pipeline.

The pipeline script:
``` groovy
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
```




