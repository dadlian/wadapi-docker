#!/bin/bash

# Install user composer libraries
cd /var/www/html/wadapi
while read dependency; do
  composer require $dependency
done </var/www/html/wadapi/project/dependencies.txt

# Substitue Environment Variables in nGinx conf
SUBSTR=s~\${BASE_URL}~$BASE_URL~g
sed -i $SUBSTR /var/www/html/conf/nginx/nginx-site.conf

# Start nGinx and redirect output to log
/start.sh > /wadapi.log 2>&1 &

# Start RabbitMQ Subscriber script
php /var/www/html/wadapi/messaging.php >> /wadapi.log 2>&1 &

# Send output log to docker log
tail -f /wadapi.log
