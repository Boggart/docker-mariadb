#MariaDB (https://mariadb.org/)

FROM alpine:latest
MAINTAINER Boggart <github.com/Boggart>

# Install MariaDB from repository.
RUN apk install --no-cache mariadb pwgen inotify-tools

# Configure the database to use our data dir.
ADD my.cnf /etc/mysql/my.cnf
RUN sed -i -e 's/^datadir\s*=.*/datadir = \/data/' /etc/mysql/my.cnf

EXPOSE 3306
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /firstrun

# Expose our data, log, and configuration directories.
VOLUME ["/data", "/var/log/mysql", "/etc/mysql"]

CMD ["/scripts/start.sh"]
