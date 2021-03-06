FROM library/ubuntu:16.04

#adds the add-apt-repo tool
RUN apt-get -y update
RUN apt-get install -y software-properties-common

#set language to japanese
RUN apt-get install -y language-pack-ja-base language-pack-ja
ENV LANG=ja_JP.UTF-8

#install oracle java 8
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

#install tomcat
WORKDIR /opt
RUN wget http://ftp.meisei-u.ac.jp/mirror/apache/dist/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz
RUN tar -zxvf apache-tomcat-8.5.35.tar.gz
RUN mv apache-tomcat-8.5.35 /tomcat

#install maven 3.3.3 & git
RUN wget http://ftp.jaist.ac.jp/pub/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
RUN tar -zxvf apache-maven-3.6.0-bin.tar.gz
RUN mv apache-maven-3.6.0 /usr/local/maven
RUN ln -s /usr/local/maven/bin/mvn /usr/bin/mvn
RUN apt-get install -y git

#install ruby 2.2.3
RUN apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev  \
                       libreadline-dev libyaml-dev libsqlite3-dev sqlite3   \
                       libxml2-dev libxslt1-dev libcurl4-openssl-dev        \
                       python-software-properties libffi-dev
RUN git clone https://github.com/sstephenson/rbenv.git /.rbenv
ENV PATH "/.rbenv/bin:$PATH"
RUN eval "$(rbenv init -)"
RUN git clone https://github.com/sstephenson/ruby-build.git /.rbenv/plugins/ruby-build
ENV PATH "/.rbenv/plugins/ruby-build/bin:$PATH"
RUN git clone https://github.com/sstephenson/rbenv-gem-rehash.git /.rbenv/plugins/rbenv-gem-rehash
RUN rbenv install 2.2.3
RUN rbenv global 2.2.3

#configure tomcat
ADD ./tomcat/context.xml /tomcat/conf/context.xml
ADD ./tomcat/server.xml /tomcat/conf/server.xml
RUN rm -rf /tomcat/webapps/*
RUN wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz
RUN tar -zxvf mysql-connector-java-5.1.47.tar.gz
ADD ./tomcat/catalina.properties /tomcat/conf/catalina.properties
RUN mkdir -p /tomcat/shared/classes /tomcat/shared/lib /tomcat/common/classes /tomcat/common/lib /tomcat/server/classes /tomcat/server/lib
RUN mv mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar /tomcat/common/lib/mysql-connector-java-5.1.47-bin.jar

#install sakai
RUN git clone https://github.com/sakaiproject/sakai.git /sakai
WORKDIR /sakai
RUN git checkout -b 11.2
RUN mvn clean install sakai:deploy -Dmaven.tomcat.home=/tomcat -Dmaven.test.skip=true


#configure sakai
ADD ./tomcat/sakai.properties /tomcat/sakai/sakai.properties

ADD ./tomcat/start-sakai.sh /scripts/

EXPOSE 8080

CMD ["/bin/bash", "/scripts/start-sakai.sh"]
