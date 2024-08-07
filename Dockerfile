FROM tomcat

COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
COPY context.xml /tmp/context.xml

RUN mv $CATALINA_HOME/webapps $CATALINA_HOME/webapps2; mv $CATALINA_HOME/webapps.dist $CATALINA_HOME/webapps; cp /tmp/context.xml $CATALINA_HOME/webapps/manager/META-INF/context.xml;

ADD sample.war /usr/local/tomcat/webapps/
ADD sampleLogin.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]