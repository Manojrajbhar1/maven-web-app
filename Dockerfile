FROM ubuntu:20.04
#RUN apt-get update && apt-get install -y wget && apt-get install -y unzip &&  apt-get install -y curl && apt-get install -y telnet && apt-get install -y nmap
RUN apt-get update && apt-get install -y wget unzip curl telnet nmap
RUN apt-get update && apt install -y openjdk-11-jdk

# Set Java environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
#ENV JRE_HOME /usr/lib/jvm/java-11-openjdk-amd64/jre
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.84/bin/apache-tomcat-9.0.84.zip \
    && unzip apache-tomcat-9.0.84.zip \
    && mv apache-tomcat-9.0.84 /usr/local/tomcat \
    && rm apache-tomcat-9.0.84.zip \
    && chmod +x -R /usr/local/tomcat/bin/*.sh

EXPOSE 8080
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
COPY target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
