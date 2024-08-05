FROM tomcat

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps2; mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps;

ADD sample.war /usr/local/tomcat/webapps/
ADD sampleLogin.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]