This project needs the war files on same folder as the dockerfile.
The project is still giving bad connection error, but the war files are being deployed. I is a certificates problem or a tomcat server.xml configuration problem.

## Actions

1. create a docker file
2. create a tomcat-users.xml file
3. create a context.xml file
4. create a server.xml file (it can be copied from the docker container after a first run)
5. create a keystore file (it can be created using keytool or openssl)
6. create a jenkins pipeline to automate the deployment of the docker container


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
``` docker run -d -p 8082:8080 -p 8443:8443 tomcat:v1  ```

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
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           maxParameterCount="1000" />

<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="150"
           scheme="https"
           secure="true"
           SSLEnabled="true"
           maxParameterCount="1000">
    <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol" />
    <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/localhost.jks"
                     certificateKeystorePassword="tomcat"
                     certificateKeystoreType="JKS"
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

the certificate must be added added to the windows trust store to avoid the browser warning.
to convert the certificate to cer file:
``` bash
keytool -exportcert -alias tomcat -keystore localhost.jks -rfc -file localhost.cer -storepass tomcat
```

to change the version of the certificate if needed:
``` bash
keytool -importkeystore -srckeystore localhost.jks -srcstoretype pkcs12 -srcstorepass tomcat -destkeystore localhost.jks -deststoretype jks -deststorepass tomcat
```

To add the certificate to the windows trust store:
``` bash
keytool -import -alias tomcat -file localhost.cer -keystore "C:\Program Files\Java\jdk-11.0.11\lib\security\cacerts" -storepass changeit
```

to test the curl command:
``` bash
curl -k https://localhost:8443/
```



