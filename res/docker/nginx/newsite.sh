#!/usr/bin/env bash

FOLDER_NAME=$1
DOMAIN=$2
PORT=$3
MULTISITE=$4

rm -f /etc/nginx/sites-enabled/${DOMAIN}

if [ ${MULTISITE} != '0' ]
then
cat << "EOF" >> /etc/nginx/sites-enabled/${DOMAIN}
map $uri $blogname{
    ~^(?P<blogpath>/[^/]+/)files/(.*)       $blogpath ;
}

map $blogname $blogid{
    default -999;
}
EOF
fi

cat << EOF >> /etc/nginx/sites-enabled/${DOMAIN}
server {
    listen ${PORT};
    root ${FOLDER_NAME};
    index index.html index.htm index.php;
    server_name ${DOMAIN} *.${DOMAIN};
    access_log /var/log/nginx/${DOMAIN}.log;
    error_log  /var/log/nginx/${DOMAIN}.error.log error;
    charset utf-8;
    error_page 404 /index.php;
EOF
if [ ${MULTISITE} != '0' ]
then
cat << "EOF" >> /etc/nginx/sites-enabled/${DOMAIN}
    location ~ ^(/[^/]+/)?files/(.+) {
        try_files /wp-content/blogs.dir/$blogid/files/$2 /wp-includes/ms-files.php?file=$2 ;
        access_log off;     log_not_found off; expires max;
    }

    location / {
     try_files $uri $uri/ /index.php?$args;
    }
    if (!-e $request_filename) {
        rewrite /wp-admin$ $scheme://$host$uri/ permanent;
        rewrite ^(/[^/]+)?(/wp-.*) $2 last;
        rewrite ^(/[^/]+)?(/.*\.php) $2 last;
    }
    location ~ \.php$ {
EOF
else
cat << "EOF" >> /etc/nginx/sites-enabled/${DOMAIN}
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    location ~ [^/]\.php(/|$) {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        if (!-f $document_root$fastcgi_script_name) {
            return 404;
         }
EOF
fi
cat << EOF >> /etc/nginx/sites-enabled/${DOMAIN}
        fastcgi_pass php;
        fastcgi_keep_conn on;
        fastcgi_index index.php;
        include fastcgi_params;
    }
    location ~ /\.ht {
        deny all;
    }
}
EOF