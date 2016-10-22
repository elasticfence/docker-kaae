#!/bin/bash

set -e

if [ "$1" =~ ^docker.* ]; then
    if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
        : ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
        sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /etc/kibana/kibana.yml
    else
        "No ES URL parameter, starting local instance... "
        service elasticsearch start
        sleep 5
    fi
else
        service elasticsearch start
        sleep 5
fi

# Patch configuration for Docker container
perl -p -i -e "s/localhost/0.0.0.0/" /etc/kibana/kibana.yml
perl -p -i -e "s/\#server.host/server.host/" /etc/kibana/kibana.yml

# Start Kibana 5
service kibana start &
tail -f /var/log/elasticsearch/*.log
