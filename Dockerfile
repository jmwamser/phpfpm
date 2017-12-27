FROM centos:latest
ENV container docker
MAINTAINER "Reynier de la Rosa" <reynier.delarosa@outlook.es>

RUN yum -y update
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install epel-release \
                   wget \
                   openssl \
                   openssl-devel \
                   zlib-devel \
                   pcre-devel \
                   yum-utils
RUN yum clean all 
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
RUN yum-config-manager --enable remi-php71
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN ACCEPT_EULA=Y yum install -y msodbcsql mssql-tools unixODBC-devel
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
RUN yum install -y gettext \ 
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
               php-mysqlnd \
               php-pecl-uuid \
               php-bcmath \
               mediainfo \
               openldap-clients \
               php-mhash \
               php-xsl \
               php-pear \
               php-soap
RUN yum clean all 
RUN useradd builder 
RUN mkdir -p /opt/lib
RUN wget https://www.openssl.org/source/openssl-1.1.0g.tar.gz -O /opt/lib/openssl-1.1.0g.tar.gz
RUN tar -zxvf /opt/lib/open* -C /opt/lib
RUN rpm -ivh http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.13.8-1.el7.ngx.src.rpm
RUN sed -i "s|--with-http_ssl_module|--with-http_ssl_module --with-openssl=/opt/lib/openssl-1.1.0g|g" /root/rpmbuild/SPECS/nginx.spec
RUN rpmbuild -ba --clean /root/rpmbuild/SPECS/nginx.spec
RUN rpm -Uvh --force /root/rpmbuild/RPMS/x86_64/nginx-1.13.8-1.el7.ngx.x86_64.rpm

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
 
EXPOSE 80 443

ADD container-files/script/* /tmp/script/
RUN chmod +x /tmp/script/bootstrap.sh

# put customized config and code files to /data

ENTRYPOINT ["/tmp/script/bootstrap.sh"]
