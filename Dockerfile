FROM tomcat:10.1-jdk17

COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
COPY context.xml /tmp/context.xml

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps2; mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps; cp /tmp/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml;

ADD sample.war /usr/local/tomcat/webapps/
ADD sampleLogin.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]