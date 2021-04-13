FROM fedora:latest


RUN mkdir /opt/confluent 
RUN mkdir /opt/confluent-hub

#Confluent Home
ENV CONFLUENT_HOME=/opt/confluent

ENV KAFKA_CONFIG=$KAFKA_CONFIG
ENV ZOOKEEPER_CONFIG=$ZOOKEEPER_CONFIG
ENV SCHEMA_REGISTRY_CONFIG=$ZOOKEEPER_CONFIG
ENV CONNECT_CONFIG=$CONNECT_CONFIG

# Zookeeper

ENV ZOOKEEPER_DATA_DIR=$ZOOKEEPER_DATA_DIR
ENV ZOOKEEPER_CLIENT_PORT=$ZOOKEEPER_CLIENT_PORT

#Kafka

ENV BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS
ENV KAFKA_SERVER_BROKER_ID=$KAFKA_SERVER_BROKER_ID
ENV ZOOKEEPER_CONNECT_IP_PORT=$ZOOKEEPER_CONNECT_IP_PORT
ENV KAFKA_SERVER_LOG_DIR=$KAFKA_SERVER_LOG_DIR

# schmea registry
ENV KAFKASTORE_TOPIC=$KAFKASTORE_TOPIC
ENV PROTOCOL_BOOTSTRAP_SERVERS=$PROTOCOL_BOOTSTRAP_SERVERS
ENV SCHEMA_REGISTRY_GROUP_ID=$SCHEMA_REGISTRY_GROUP_ID
ENV SCHEMA_REGISTRY_LEADER_ELIGIBILITY=$SCHEMA_REGISTRY_LEADER_ELIGIBILITY

# Kafka connect
ENV CONNECT_REST_PORT=$CONNECT_REST_PORT
ENV CONNECT_OFFSETS=$CONNECT_OFFSETS
ENV CONNECT_KEY_CONVERTER=$CONNECT_KEY_CONVERTER
ENV SCHEMA_REGISTRY_URL=$SCHEMA_REGISTRY_URL
ENV CONNECT_VALUE_CONVERTER=$CONNECT_VALUE_CONVERTER
ENV SCHEMA_REGISTRY_LISTENER=$SCHEMA_REGISTRY_LISTENER
ENV CONNECT_PLUGIN_PATH=/usr/share/java/,$CONFLUENT_HOME/share/confluent-hub-components/


# install openjdk8

#RUN dnf update -y && dnf install epel-release  -y
RUN dnf install wget zip moreutils gettext unzip java-1.8.0-openjdk.x86_64 -y && dnf clean all

# install conflunet

WORKDIR $CONFLUENT_HOME
RUN wget https://packages.confluent.io/archive/6.1/confluent-community-6.1.1.tar.gz -P . && tar -xvzf confluent-community-6.1.1.tar.gz && mv confluent-6.1.1/* . && rm -rf confluent-6.1.1 confluent-community-6.1.1.tar.gz

# install confluent hub

RUN wget http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz -P /opt/confluent-hub
WORKDIR /opt/confluent-hub 
RUN tar -xvzf confluent-hub-client-latest.tar.gz && rm -rf confluent-hub-client-latest.tar.gz
ENV CONFLUENT_HUB /opt/confluent-hub/bin

# Export path

ENV PATH $PATH:$CONFLUENT_HOME:$CONFLUENT_HUB

# install jdbc connector

RUN wget https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-jdbc/versions/10.1.0/confluentinc-kafka-connect-jdbc-10.1.0.zip -P $CONFLUENT_HOME/share/confluent-hub-components/ && unzip $CONFLUENT_HOME/share/confluent-hub-components/confluentinc-kafka-connect-jdbc-10.1.0.zip && rm -rf confluentinc-kafka-connect-jdbc-10.1.0.zip

# Copy confleunt config to docker

WORKDIR $CONFLUENT_HOME
COPY config/* config/

# startup

COPY startup.sh .
RUN chmod +x ./startup.sh

ENTRYPOINT ./startup.sh
