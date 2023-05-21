#!/bin/bash

echo "Waiting for MySQL to start..."
until mysqladmin ping -hbdm1 -uroot -psenha1; do
  sleep 1
done

echo "Configuring replication..."

# Get the current binary log file and position from db1
LOG_FILE=$(mysql -hbdm1 -uroot -psenha1 -e "SHOW MASTER STATUS \G" | awk '/File:/ {print $2}')
LOG_POS=$(mysql -hbdm1 -uroot -psenha1 -e "SHOW MASTER STATUS \G" | awk '/Position:/ {print $2}')

# Configure db2 as a replica of db1
mysql -hbdm2 -uroot -psenha1 -e "CHANGE MASTER TO MASTER_HOST='bdm1', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='$LOG_FILE', MASTER_LOG_POS=$LOG_POS; START SLAVE;"
mysqldump -hbdm1 -uroot -psenha1 --all-databases | mysql -hlocalhost -uroot -psenha1

echo "Replication configured successfully!"

