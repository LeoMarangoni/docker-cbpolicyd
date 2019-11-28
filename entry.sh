#!/bin/bash

printenv CB_DB_HOST > /dev/null || { echo "CB_DB_HOST not found"; exit; } 
printenv CB_DB_USER > /dev/null || { echo "CB_DB_USER not found"; exit; }
printenv CB_DB_PASS > /dev/null || { echo "CB_DB_PASS not found"; exit; }



envsubst < /etc/cluebringer/cluebringer.conf.in > /etc/cluebringer/cluebringer.conf
DOLLAR='$' envsubst < /etc/cluebringer/cluebringer-webui.conf.in > /etc/cluebringer/cluebringer-webui.conf


if [ $CB_INIT_DB -eq 1 ]
then

    echo "Initializing database..."
    mv /usr/share/doc/postfix-cluebringer/database/policyd-db.mysql.gz /tmp/db.sql.gz
    gunzip /tmp/db.sql.gz
    sed -i -e 's/TYPE=InnoDB/ENGINE=InnoDB/g' /tmp/db.sql
    mysql -u$CB_DB_USER -p$CB_DB_PASS -h$CB_DB_HOST $CB_DB_NAME < /tmp/db.sql
    if [ $? -eq 0 ]
    then
        echo "Database initialized sucessfuly" 
        exit 0
    else
        echo "Failed to initialize Database" 
        exit 1
    fi

fi


if [ $CB_SERVICE_WEBUI_ENABLED -eq 1 ]
then

    echo "Starting webui..."
    echo "Starting PHP..."
    /etc/init.d/php7.0-fpm start &> /dev/null && echo "DONE!"
    echo "Starting apache   ..."
    /etc/init.d/apache2 start &> /dev/null && echo "DONE!"
fi

/usr/bin/perl /usr/sbin/cbpolicyd --config=/etc/cluebringer/cluebringer.conf