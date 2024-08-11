FROM tomcat:10.0.0-M7-jdk11-openjdk-slim

COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
COPY context.xml /tmp/context.xml
COPY localhost.key /usr/local/tomcat/conf/localhost.key
COPY localhost.pem /usr/local/tomcat/conf/localhost.pem

#COPY keystore.jks /usr/local/tomcat/conf/keystore.jks
COPY server.xml /usr/local/tomcat/conf/server.xml

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps2; mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps; cp /tmp/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml;

ADD sample.war /usr/local/tomcat/webapps/
ADD sampleLogin.war /usr/local/tomcat/webapps/

EXPOSE 8080
EXPOSE 8443

CMD ["catalina.sh", "run"]