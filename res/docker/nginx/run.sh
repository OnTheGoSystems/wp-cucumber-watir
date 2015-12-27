#!/usr/bin/env bash

service nginx start
chmod -R 777 /www

while true
do
        inotifywait --exclude .swp -e create -e modify -e delete -e move  /etc/nginx/sites-enabled
        # Check NGINX Configuration Test
        # Only Reload NGINX If NGINX Configuration Test Pass
        nginx -t
        if [ $? -eq 0 ]
        then
                echo "Reloading Nginx Configuration"
                service nginx reload
        fi
done

