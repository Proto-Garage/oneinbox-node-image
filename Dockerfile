FROM phusion/baseimage:0.9.22

CMD ["/sbin/my_init"]

# install logstash
RUN apt-get update && apt-get install -y apt-transport-https default-jre default-jdk \
  && curl -sS https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
  && echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list \
  && apt-get update \
  && apt-get install -y logstash
  && /usr/share/logstash/bin/logstash-plugin install logstash-output-loggly

# install node
RUN apt-get install -y software-properties-common \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && node -v
    && npm install -g pm2

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*