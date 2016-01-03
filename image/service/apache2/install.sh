#!/bin/bash -e
# this script is run during the image build

ln -s /container/service/apache2/assets/conf-available/registry-proxy.conf /etc/apache2/conf-available/registry-proxy.conf
ln -s /container/service/apache2/assets/sites-available/registry-proxy.conf /etc/apache2/sites-available/registry-proxy.conf

a2enmod headers auth_basic authnz_ldap access_compat ssl proxy_http

a2enconf registry-proxy

# Remove apache default host
a2dissite 000-default
rm -rf /var/www/html

a2ensite registry-proxy
