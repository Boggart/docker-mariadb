#MariaDB (https://mariadb.org/)

FROM alpine:latest
MAINTAINER Boggart <github.com/Boggart>

# Install MariaDB from repository.
RUN apk install --no-cache mariadb pwgen inotify-tools

#disable syslog
RUN rm /etc/mysql/conf.d/mysqld_safe_syslog.cnf

# Configure the database to use our data dir.
RUN sed -i -e 's/^datadir\s*=.*/datadir = \/data/' /etc/mysql/my.cnf

# Configure MariaDB to listen on any address.
RUN sed -i -e 's/^bind-address/#bind-address/' /etc/mysql/my.cnf

# Change the innodb-buffer-pool-size to 128M (default is 256M).
# This should make it friendlier to run on low memory servers.
RUN sed -i -e 's/^innodb_buffer_pool_size\s*=.*/innodb_buffer_pool_size = 128M/' /etc/mysql/my.cnf

EXPOSE 3306
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /firstrun

# Expose our data, log, and configuration directories.
VOLUME ["/data", "/var/log/mysql", "/etc/mysql"]

CMD ["/scripts/start.sh"]
