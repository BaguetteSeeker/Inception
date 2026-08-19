FROM debian:bookworm

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /var/run/mysqld /var/log/mysql /var/lib/mysql \
    && chown -R mysql:mysql /var/run/mysqld /var/log/mysql /var/lib/mysql \
    && chmod 755 /var/run/mysqld /var/log/mysql /var/lib/mysql

# Copy configuration
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/init_db.sh /usr/local/bin/

# Set permissions
RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

ENTRYPOINT ["init_db.sh"]
