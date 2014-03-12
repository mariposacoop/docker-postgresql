# docker-postgresql

This is a basic docker image for postgresql on Ubuntu precise. Build it locally or
just pull it from the docker index and run it with something like the following:
```
$ docker run -d -p 5432:5432 -v /tmp/postgresql:/data -t gsf747/postgresql
```

The database is configured to accept md5 logins from anywhere, and it's initialised
with a superuser with the username/password "super/pass". The data volume is shared
with the host for persistence between runs.

This project was heavily influenced by https://github.com/Painted-Fox/docker-postgresql.
