FROM maven:3-openjdk-11

RUN apt update \
	&& apt dist-upgrade -y \
	&& apt install git -y

RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git

RUN cd /boxfuse-sample-java-war-hello && mvn package
RUN cp /boxfuse-sample-java-war-hello/target/*.war /usr/local/