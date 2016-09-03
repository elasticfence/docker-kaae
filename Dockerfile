# Linux OS
FROM elasticsearch:2.3.5

# Maintainer
MAINTAINER lmangani <lorenzo.mangani@gmail.com>

# Setup Packages & Permissions
RUN apt-get update && apt-get clean \
 && wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 \
 && chmod +x /dumb-init \
 && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
 && apt-get install -y nodejs git \
 && cd /tmp && wget https://download.elastic.co/kibana/kibana/kibana-4.5.4-linux-x64.tar.gz \
 && tar zxvf /tmp/kibana-4.5.4-linux-x64.tar.gz && mv kibana-4.5.4-linux-x64 /opt/kibana \
 && git clone https://github.com/elasticfence/kaae && cd kaae && npm install && npm run package \
 && /opt/kibana/bin/kibana plugin --install kaae -u file://`pwd`/kaae-latest.tar.gz \
 && /usr/share/elasticsearch/bin/plugin install https://raw.githubusercontent.com/elasticfence/elasticsearch-http-user-auth/2.3.5/jar/elasticfence-2.3.5-SNAPSHOT.zip \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

# Expose Default Ports
EXPOSE 5601
EXPOSE 9200
EXPOSE 9300

# Exec on start
ENTRYPOINT ["/dumb-init", "--"]
CMD ["/opt/entrypoint.sh"]
