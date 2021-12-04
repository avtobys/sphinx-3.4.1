#!/usr/bin/env bash

echo -n "Enter MySQL root password(default is empty string): "

read MYSQL_PASSWORD

echo "Check MySQL version..."

if [[ -z "$MYSQL_PASSWORD" ]]; then
  mysql_version=$(mysql -Ne "SELECT VERSION();")
else
  mysql_version=$(mysql -p$MYSQL_PASSWORD -Ne "SELECT VERSION();")
fi

if [[ -z "$mysql_version" ]]; then
  echo "Can't connect to MySQL"
  exit 1
fi

echo $mysql_version

echo "Loading example dump from etc/example.sql"

if [[ -z "$MYSQL_PASSWORD" ]]; then
  mysql < etc/example.sql
else
  mysql -p$MYSQL_PASSWORD < etc/example.sql
fi

sed -i -r "s/^(\s*)sql_pass(\s*)=.*\$/\1sql_pass\2= $MYSQL_PASSWORD/" etc/sphinx.conf

echo 'Path will be created:

/etc/sphinx (sphinx.conf will be hosted here)
/var/lib/sphinx/data (paths to index and binlog files)
/var/log/sphinx (paths to log files)

WARNING: If directories exist, their contents will be removed

Next files:

bin/indexer
bin/indextool
bin/searchd
bin/wordbreaker

will be copied here:

/usr/local/bin/indexer
/usr/local/bin/indextool
/usr/local/bin/searchd
/usr/local/bin/wordbreaker

will be created service unit file:

/usr/lib/systemd/system/sphinx.service

will be created logrotate file:

/etc/logrotate.d/sphinx

'

echo -n "Press [Y] to continie or any key to cancel: "

read CONFIRM

if [[ "${CONFIRM}" != "y" && "${CONFIRM}" != "Y" ]]; then
    echo "Canceled..."
    exit 1
fi

if [ ! -d "/etc" ]; then
    echo "ERROR: No such directory /etc"
fi

if [ ! -d "/var/lib" ]; then
    echo "ERROR: No such directory /var/lib"
fi

if [ ! -d "/var/log" ]; then
    echo "ERROR: No such directory /var/log"
fi

if [ ! -d "/etc/logrotate.d" ]; then
    echo "ERROR: No such directory /etc/logrotate.d"
fi

systemctl stop sphinx.service
systemctl disable sphinx.service


if [ -d "/etc/sphinx" ]; then
    rm -r /etc/sphinx
    echo "/etc/sphinx removed..."
fi

if [ -d "/var/lib/sphinx/data" ]; then
    rm -r /var/lib/sphinx/data
    echo "/var/lib/sphinx/data removed..."
fi

if [ -d "/var/log/sphinx" ]; then
    rm -r /var/log/sphinx
    echo "/var/log/sphinx removed..."
fi

chmod +x bin/*
mkdir -p /etc/sphinx /var/lib/sphinx/data /var/log/sphinx
cp etc/sphinx.conf /etc/sphinx/sphinx.conf
cp bin/indexer /usr/local/bin/indexer
cp bin/indextool /usr/local/bin/indextool
cp bin/searchd /usr/local/bin/searchd
cp bin/wordbreaker /usr/local/bin/wordbreaker
cp logrotate/sphinx /etc/logrotate.d/sphinx

echo "Testing indexer... Create indexes sphinx_test.documents"

/usr/local/bin/indexer -c /etc/sphinx/sphinx.conf --all

printf "\n\nCopy unit service file... /usr/lib/systemd/system/sphinx.service
and start sphinx.service
\n"

cp sphinx.service /usr/lib/systemd/system/sphinx.service
systemctl daemon-reload
systemctl enable sphinx.service
systemctl start sphinx.service
IFS=''
echo $(systemctl status sphinx.service)

echo "Check Sphinx version..."
mysql -h127.0.0.1 -P9810 -Ne "SELECT VERSION();"
echo "Check Sphinx index_documents..."
mysql -h127.0.0.1 -P9810 -Ne "SHOW TABLES;"
echo "Check match query to mysql api..."
mysql -h127.0.0.1 -P9810 -Ne "SELECT * FROM index_documents WHERE MATCH('test')"
echo "Check match query to php api..."
php -f api/test.php
