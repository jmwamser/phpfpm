FROM centos:latest
ENV container docker
MAINTAINER "Reynier de la Rosa" <reynier.delarosa@outlook.es>

RUN yum -y update
RUN yum -y install epel-release \
                   wget \
                   yum-utils
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
RUN yum-config-manager --enable remi
RUN yum-config-manager --enable remi-php71
RUN yum install -y msodbcsql \
               php-fpm \ 
               php-cli \
               php-common \
               php-gd \
               php-intl \
               php-json \
               php-ldap \
               php-mbstring \
               php-mcrypt \
               php-opcache \
               php-pdo \
               php-pecl-zip \
               php-soap \
               php-sqlsrv \
               php-xml \
               php-mysql \
               php-pecl-uuid \
               mediainfo \
               openldap-clients
RUN yum clean all 
 
RUN ln -sf /dev/stderr /var/log/php-fpm/error.log
 
EXPOSE 9050

ADD container-files/script/* /tmp/script/
RUN chmod +x /tmp/script/bootstrap.sh

# put customized config and code files to /data

ENTRYPOINT ["/tmp/script/bootstrap.sh"]
