#!/bin/bash

# Exit on error
set -e

# Set socket path
SOCKET_PATH="/var/run/mysqld/mysqld.sock"
FLAG_FILE="/var/lib/mysql/.db_configured" 
# Load secrets
MYSQL_ROOT_PASSWORD=$(cat "$SECRETS_PATH/mysql_root_pwd")
MYSQL_PASSWORD=$(cat "$SECRETS_PATH/mysql_pwd")

# --- ANTI-CRASH CLEANUP ---
echo "Cleaning up old sockets and pid files..."
rm -f /var/run/mysqld/mysqld.sock
rm -f /var/run/mysqld/mysqld.pid

# --- Adding permissions over volume at runtime ---
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod 755 /var/lib/mysql /var/run/mysqld

##### Performs initial setup if data directory does not exist
echo "MariaDB initializing..."
if [ ! -f "$FLAG_FILE" ] && [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

	echo "Initializing data directory..."
   	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	# Start the server (no networking for setup)
	echo "Starting temporary MariaDB server for setup..."
	mysqld --skip-networking --socket=$SOCKET_PATH --user=mysql &
	pid="$!"

	echo "Waiting for MariaDB to be ready..."
	until mysqladmin --socket=/var/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
   		sleep 1
	done

	# Run setup SQL: create database and users
	echo "Running setup SQL..."
	mysql --socket=$SOCKET_PATH -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
	#Flags MYSQL_DATABASE creation
	touch "$FLAG_FILE"

	# Temp srv shutdown
	echo "Shutting down temporary MariaDB..."
	# Auth shutdown (might crash in case of occasional delayed synchronization from mysqladmin privileges)
	mysqladmin --socket=$SOCKET_PATH -u root --password="${MYSQL_ROOT_PASSWORD}" shutdown
	# No auth shutdown (ASA as you ALTER USER 'root' mariaDB forgoes the unix_socked ID process to a regular one / otherwise do not need auth because MariaDB delegates permissions through unix_socket from bash)
	#mysqladmin --socket="$SOCKET_PATH" shutdown

	# Wait for shutdown
	wait "$pid" || true

fi

##### Start MariaDB normally (with networking)
echo "Initialization complete. Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=$SOCKET_PATH
