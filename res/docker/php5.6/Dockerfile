FROM php:5.6-fpm

ENV TERM linux
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN apt-get update && apt-get install -y locales curl wget curl git build-essential gnupg2 libssl-dev libffi-dev autoconf
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
   && locale-gen en_US.utf8 \
   && /usr/sbin/update-locale LANG=en_US.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y mysql-client libmysqlclient-dev netcat unzip \
    libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev sendmail

RUN docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install mbstring

RUN sed -i 's/^user\s.*/user = root/' /usr/local/etc/php-fpm.conf
RUN sed -i 's/^group\s.*/group = root/' /usr/local/etc/php-fpm.conf
RUN sed -i 's/^listen\s.*/listen = \/var\/run\/php\/php5-fpm.sock\nlisten.mode = 0777/' /usr/local/etc/php-fpm.conf

#WP CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN echo "alias wp=\"wp --allow-root \"" >> /root/.bash_profile

COPY /conf /usr/local/etc/php
COPY /test-scripts /test-scripts

COPY wait.sh /wait.sh
COPY run.sh /run.sh
COPY newsite.sh /newsite.sh
COPY export_site.php /export_site.php
RUN chmod +x /run.sh
RUN chmod +x /wait.sh
RUN chmod +x /newsite.sh
RUN chmod +x /test-scripts/*.sh
RUN echo "mkdir -p /wp && cd /wp && wp core download --allow-root && rm -rf /wp/wp-content/plugins" | /bin/bash -l
COPY /plugins /wp/wp-content/plugins
WORKDIR /

CMD ["bash", "-l", "run.sh"]