#!/bin/bash

# If /data is empty fill it with initial postgresql data
if find /data -maxdepth 0 -empty | read v
then
  cp -R /var/lib/postgresql/9.1/main/* /data
fi

# Make sure permissions are correct
chown -R postgres /data
chmod -R 700 /data

su postgres -c '/usr/lib/postgresql/9.1/bin/postgres -D /etc/postgresql/9.1/main'
