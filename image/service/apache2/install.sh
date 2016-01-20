#!/bin/bash -e
# this script is run during the image build

a2enmod headers auth_basic authnz_ldap access_compat ssl proxy_http

# Remove apache default host
a2dissite 000-default
rm -rf /var/www/html
