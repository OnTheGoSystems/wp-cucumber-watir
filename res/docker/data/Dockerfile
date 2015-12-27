FROM debian:jessie

ENV TERM linux
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN apt-get update && apt-get install -y locales curl wget curl git build-essential gnupg2 libssl-dev libffi-dev autoconf
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
   && locale-gen en_US.utf8 \
   && /usr/sbin/update-locale LANG=en_US.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y unzip rsync
RUN chmod 400 /root/.ssh/*
RUN mkdir -p /repos
WORKDIR /repos
RUN mkdir -p /www
RUN mkdir /var/run/mysqld && chmod -R 777 /var/run/mysqld
RUN mkdir /var/run/php && chmod -R 777 /var/run/php
VOLUME /var/run/mysqld
VOLUME /var/run/php
VOLUME /www
VOLUME /repos
COPY rsyncd.conf /etc/rsyncd.conf
COPY run.sh /run.sh
RUN chmod +x /run.sh && mkdir /data

EXPOSE 873

CMD ["/bin/bash", "-lc", "/run.sh"]