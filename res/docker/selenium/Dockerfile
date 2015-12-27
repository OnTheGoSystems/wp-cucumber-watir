FROM debian:stretch

ENV TERM linux
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN apt-get update && apt-get install -y locales curl wget curl git build-essential gnupg2 libssl-dev libffi-dev autoconf
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
   && locale-gen en_US.utf8 \
   && /usr/sbin/update-locale LANG=en_US.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Firefox
RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list
RUN gpg2 --keyserver pgp.mit.edu --recv-keys 3EE67F3D0FF405B2
RUN apt-get update && apt-get install -y --force-yes unzip openjdk-8-jdk firefox libav-tools bzip2 gawk g++ gcc libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 libgdbm-dev libncurses5-dev automake libtool bison pkg-config xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps imagemagick libasound2 libdbus-glib-1-2 libxt-dev libfreetype6 libfontconfig libxrender1 libxdamage-dev libxext-dev libxcomposite-dev libgtk2.0-bin

# Selenium
RUN mkdir /selenium
WORKDIR /selenium
RUN wget -O /selenium/selenium.jar http://goo.gl/RXxPg6

COPY run.sh /run.sh
RUN chmod +x /run.sh
EXPOSE 4444

CMD ["bash", "-l", "/run.sh"]