#!/bin/bash

# Install user composer libraries
cd /var/www/html/project
composer install

# Substitue Environment Variables in nGinx conf
SUBSTR=s~\${BASE_URL}~$BASE_URL~g
sed -i $SUBSTR /var/www/html/conf/nginx/nginx-site.conf

# Start nGinx and redirect output to log
/start.sh > /wadapi.log 2>&1 &

# Start RabbitMQ Subscriber script
php /var/www/html/project/messaging.php >> /wadapi.log 2>&1 &

# Ensure mounted project files are editable
sleep 3
chown -R 1000:1000 /var/www/html/project

# Send output log to docker log
tail -f /wadapi.log