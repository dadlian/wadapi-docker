#!/bin/bash

SUBSTR=s~\${BASE_URL}~$BASE_URL~g
sed -i $SUBSTR /var/www/html/conf/nginx/nginx-site.conf

# Start nGinx and redirect output to log
/start.sh > /wadapi.log 2>&1 &

# Start RabbitMQ Subscriber script
php /var/www/html/project/messaging.php > /wadapi.log 2>&1 &

# Send output log to docker log
tail -f /wadapi.log