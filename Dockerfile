# Pull base image  
FROM ubuntu:13.10  
  
MAINTAINER zing wang "zing.jian.wang@gmail.com"  
  
# update source  
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe"> /etc/apt/sources.list  
RUN apt-get update  
  
# Install curl  
RUN apt-get -y install curl  
  
# Install JDK 7  
RUN cd /tmp &&  curl -L 'http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz  
RUN mkdir -p /usr/lib/jvm  
RUN mv /tmp/jdk1.7.0_65/ /usr/lib/jvm/java-7-oracle/  
  
# Set Oracle JDK 7 as default Java  
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-7-oracle/bin/java 300     
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-7-oracle/bin/javac 300     
  
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/  
  
# Install tomcat6  
RUN cd /tmp && curl -L 'http://archive.apache.org/dist/tomcat/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz' | tar -xz  
RUN mv /tmp/apache-tomcat-6.0.35/ /opt/tomcat6/  
  
ENV CATALINA_HOME /opt/tomcat6  
ENV PATH $PATH:$CATALINA_HOME/bin  
  
ADD tomcat6.sh /etc/init.d/tomcat6  
RUN chmod 755 /etc/init.d/tomcat6
  
# Expose ports.  
EXPOSE 8080  
  
# Define default command.  
ENTRYPOINT service tomcat6 start && tail -f /opt/tomcat6/logs/catalina.out 