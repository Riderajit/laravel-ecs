#Download the docker alpine base image from ECR repository.
FROM alpine:latest

#Do a package manager refresh to update newer package informations.
RUN apk update

#Install Vim editor using package manager.
RUN apk add vim

#Install curl command using package manager.
RUN apk add curl

#Install openrc command to run init services
RUN apk add openrc --no-cache

#Install apache package using package manager.
RUN apk add apache2

#Install php package using package manager.
RUN apk add php php-intl php-openssl php-curl php-ldap php-pear php-common php-fpm php-mysqlnd php-pdo php-bcmath php-soap php-gd php-xml php-zip  php-apache2 php-pdo_mysql php-ctype php-json php-zlib php-dom php-session php-fileinfo  php-gettext php-imap  php-exif  php-imap  php-redis php-cli php-mbstring  php-mysqli php-simplexml php-xmlreader php-xmlwriter php-sodium php-phar php-tokenizer php-pgsql
#RUN mkdir /run/apache2
#copy locally modified httpd.conf to docker build command to have the customized version of httpd in the docker image.
COPY httpd.conf /etc/apache2/httpd.conf

#Work directory of location
WORKDIR /var/www/localhost/htdocs

#Copy the basic directory to docker image.
COPY ./ /var/www/localhost/htdocs/./

#Change ownership to apache to avoid any application permission errors.
RUN chown -R apache:apache /var/www/localhost/htdocs

#Installing composer package using culr 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Updating the composer 
RUN yes | composer update

#Installing the composer 
RUN composer install --no-interaction

#Generate the key 
#RUN php artisan key:generate

#RUN yes | php artisan passport:keys
RUN php artisan cache:clear

#Update the changes need to clear the config 
RUN php artisan config:clear

RUN php artisan route:clear

#Start the container with apache process.
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]

#Expose the port 80 of the container to enable load balancer to communicate
EXPOSE 80

