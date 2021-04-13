#!/bin/bash

set -x

# Substitue environment variables in actual $CONFLUENT_HOME/configs
envsubst  < $CONFLUENT_HOME/config/zookeeper.properties | sponge $CONFLUENT_HOME/config/zookeeper.properties
envsubst  < $CONFLUENT_HOME/config/server.properties | sponge $CONFLUENT_HOME/config/server.properties
envsubst  < $CONFLUENT_HOME/config/schema-registry.properties | sponge $CONFLUENT_HOME/config/schema-registry.properties
envsubst  < $CONFLUENT_HOME/config/connect-avro-standalone.properties | sponge $CONFLUENT_HOME/config/connect-avro-standalone.properties

# start zookeeper
$CONFLUENT_HOME/bin/zookeeper-server-start -daemon $ZOOKEEPER_CONFIG

sleep 15

# start kafka broker
$CONFLUENT_HOME/bin/kafka-server-start -daemon $KAFKA_CONFIG

sleep 5

# start schema registry
$CONFLUENT_HOME/bin/schema-registry-start -daemon $SCHEMA_REGISTRY_CONFIG

sleep 5
echo $CONNECT_CONFIG


# start kafka connect
$CONFLUENT_HOME/bin/connect-standalone -daemon $CONNECT_CONFIG $CONFLUENT_HOME/etc/kafka/connect-file-sink.properties


while :
do
	echo "Confluent Running "
	sleep 5
done

