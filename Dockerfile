# VERSION 0.0.0
# DOCKER-VERSION 0.8.0

FROM stackbrew/ubuntu:precise
MAINTAINER Gabriel Farrell gsf747@gmail.com

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes postgresql inotify-tools

# Create default user super/pass
RUN su postgres -c '/usr/lib/postgresql/9.1/bin/postgres -D /etc/postgresql/9.1/main' & \
  inotifywait -e create /run/postgresql && \
  su postgres -c "echo \"CREATE ROLE super WITH ENCRYPTED PASSWORD 'pass'; ALTER ROLE super WITH SUPERUSER; ALTER ROLE super WITH LOGIN;\" | psql" && \
  kill `cat /run/postgresql/9.1-main.pid` && \
  inotifywait -e delete /run/postgresql

# Configure the database to use our data dir
RUN sed -i -e"s/data_directory =.*$/data_directory = '\/data'/" /etc/postgresql/9.1/main/postgresql.conf

# Allow connections from anywhere.
RUN sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" /etc/postgresql/9.1/main/postgresql.conf
RUN echo "host    all    all    0.0.0.0/0    md5" >> /etc/postgresql/9.1/main/pg_hba.conf

ADD start.sh start.sh
RUN chmod +x start.sh
CMD ["/start.sh"]

# Store data persistently on the host
VOLUME ["/data"]

EXPOSE 5432
