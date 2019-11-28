FROM ubuntu:16.04
MAINTAINER Leo Marangoni <leonardo.marangoni@inova.net>


RUN export DEBIAN_FRONTEND=noninteractive && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update -y

RUN apt-get install -y \
    gettext-base \
    mysql-client \
    php7.0-mysql \
    libdbd-mysql-perl \
    postfix-cluebringer

RUN rm -f /etc/init.d/postfix-cluebringer && \
    rm -f /var/www/html/index.html && \
    rm -f /etc/apache2/sites-enabled/* && \
    a2enmod proxy_fcgi && \
    a2enconf php7.0-fpm
    

ADD cb.conf /etc/cluebringer/cluebringer.conf.in
ADD cb-webui.conf /etc/cluebringer/cluebringer-webui.conf.in
ADD site.conf /etc/apache2/sites-enabled/webui.conf


ENV CB_DB_NAME policyd
ENV CB_BYPASS_MODE pass
ENV CB_BYPASS_TIMEOUT 30
ENV CB_LOG_LEVEL 2
ENV CB_SERVICE_ACCESS_CONTROL_ENABLED 1
ENV CB_SERVICE_GREY_LISTING_ENABLED 1
ENV CB_SERVICE_CHECK_HELO_ENABLED 1
ENV CB_SERVICE_CHECK_SPF_ENABLED 1
ENV CB_SERVICE_QUOTAS_ENABLED 1
ENV CB_SERVICE_WEBUI_ENABLED 1
ENV CB_INIT_DB 0

ADD entry.sh /bin/policyd

RUN chmod +x /bin/policyd
ENTRYPOINT ["/bin/policyd"]

EXPOSE 80 10031
