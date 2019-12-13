FROM adoptopenjdk/openjdk8:latest

RUN mkdir -p /opt/secor

#this might not be needed, but fixes a warning for missing native hadoop libs
RUN curl -s http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz | tar -xz -C /usr/local/
RUN ln -s /usr/local/hadoop-2.7.7 /usr/local/hadoop
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/hadoop/lib/native
ENV PATH $PATH:/usr/local/hadoop/bin

ADD target/secor-*-bin.tar.gz /opt/secor/

COPY src/main/scripts/docker-entrypoint.sh /docker-entrypoint.sh

#need this because something wrong in pom.xml
COPY src/main/config/kafka-2.0.0/kafka.properties /opt/secor/kafka.properties
#remove tests jar because it contains bogus config
RUN rm -f /opt/secor/*-tests.jar

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
