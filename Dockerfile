FROM phusion/baseimage:0.9.22

CMD ["/sbin/my_init"]

# install logstash
RUN apt-get update && apt-get install -y apt-transport-https default-jre default-jdk \
  && curl -sS https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
  && echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list \
  && apt-get update \
  && apt-get install -y logstash \
  && /usr/share/logstash/bin/logstash-plugin install logstash-output-loggly \
  && /usr/share/logstash/bin/logstash-plugin install logstash-filter-json

# install node
RUN apt-get install -y software-properties-common \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && node -v

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APP_DIR=/srv/node LOG_DIR=/var/log/node

RUN mkdir -p $APP_DIR && mkdir -p $LOG_DIR

RUN mkdir /etc/service/node
COPY node.run.sh /etc/service/node/run
RUN chmod +x /etc/service/node/run

COPY node.logrotate.conf /etc/logrotate.d/node
COPY node.logstash.conf /etc/logstash/conf.d/node.conf

RUN mkdir /etc/service/logstash
COPY logstash.run.sh /etc/service/logstash/run
RUN chmod +x /etc/service/logstash/run
