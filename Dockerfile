FROM phusion/baseimage:0.9.22

CMD ["/sbin/my_init"]

# install node
RUN apt-get install -y software-properties-common \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && node -v

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APP_DIR=/srv/node LOG_DIR=/var/log/node

RUN mkdir -p $APP_DIR && mkdir -p $LOG_DIR

# add node daemon
RUN mkdir /etc/service/node
COPY node.run.sh /etc/service/node/run
RUN chmod +x /etc/service/node/run

COPY node.logrotate.conf /etc/logrotate.d/node
COPY node.logstash.conf /etc/logstash/conf.d/node.conf
