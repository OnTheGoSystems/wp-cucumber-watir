FROM debian:squeeze
RUN apt-get update \
    && apt-get install -y \
        autoconf2.13 \
        libbz2-dev \
        libcurl4-openssl-dev \
        libltdl-dev \
        libmcrypt-dev \
        libevent-dev \
        libmhash-dev \
        libmysqlclient-dev \
        libpcre3-dev \
        libpng12-dev \
        libxml2-dev \
        make \
        patch \
        xmlstarlet \
		wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget http://museum.php.net/php5/php-5.2.16.tar.gz
RUN wget http://download.suhosin.org/suhosin-patch-5.2.16-0.9.7.patch.gz
RUN wget http://php-fpm.org/downloads/php-5.2.16-fpm-0.5.14.diff.gz
RUN gunzip /tmp/*.gz && tar xf /tmp/php-5.2.16.tar -C /tmp
WORKDIR /tmp/php-5.2.16

RUN patch -p1 -i ../php-5.2.16-fpm-0.5.14.diff && \
    patch -p1 -i ../suhosin-patch-5.2.16-0.9.7.patch

RUN ./buildconf --force
RUN ./configure \
    --enable-fastcgi \
    --enable-fpm \
    --enable-mbstring \
    --enable-sockets \
    --with-config-file-path=/etc/php \
    --with-curl \
    --with-fpm-conf=/etc/php/php-fpm.conf \
    --with-fpm-log=/var/log/php/php_errors.log \
    --with-fpm-pid=/var/run/php/php-fpm.pid \
    --with-gd \
    --with-gettext \
    --with-libdir \
    --with-libdir=lib64 \
    --with-mcrypt \
    --with-mhash \
    --with-mysql \
    --with-mysql-sock \
    --with-mysqli \
    --with-openssl \
    --with-pcre-regex \
    --with-png-dir \
    --with-zlib \
    --without-sqlite

RUN make && make install

RUN apt-get remove -y autoconf2.13

RUN rm -rf /tmp/* /var/tmp/*

WORKDIR /

COPY init.sh /init
RUN chmod +x /init
ENTRYPOINT ["/init"]

EXPOSE 9999
CMD ["php-cgi", "--fpm"]
