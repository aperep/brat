# based on cassj/brat
# start from a base ubuntu image
FROM ubuntu
MAINTAINER Alexander Perepechko <a@perep.ru>

# set users cfg file
ARG USERS_CFG=users.json

# Install pre-reqs
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl vim sudo wget rsync apache2 python supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fetch  brat
COPY src-copy /var/www/brat

# create a symlink so users can mount their data volume at /bratdata rather than the full path
RUN mkdir /bratdata && mkdir /bratcfg \
 && chown -R www-data:www-data /bratdata /bratcfg \
 && chmod o-rwx /bratdata /bratcfg \
 && ln -s /bratdata /var/www/brat/data \
 && ln -s /bratcfg /var/www/brat/cfg 

# And make that location a volume
VOLUME /bratdata
VOLUME /bratcfg

COPY brat_install_wrapper.sh /usr/bin/
RUN chmod +x /usr/bin/brat_install_wrapper.sh  \
 && chmod -R +x /var/www/brat/*
  

# Make sure apache can access it
RUN chown -R www-data:www-data /var/www/brat/

COPY 000-default.conf /etc/apache2/sites-available/

# add the user patching script
COPY user_patch.py /var/www/brat/

# Enable cgi
RUN a2enmod cgi

EXPOSE 80

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/

CMD ["/usr/bin/supervisord"]





