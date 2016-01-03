#!/bin/bash -e

FIRST_START_DONE="/etc/docker-registry-ldap-auth-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

    # check certificat and key or create it
    cfssl-helper registry "/container/service/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_CRT_FILENAME" "/container/service/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_KEY_FILENAME" "/container/service/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_CA_CRT_FILENAME"

    # add CA certificat config if CA cert exists
    if [ -e "/container/service/apache2/assets/certs/$PHPLDAPADMIN_HTTPS_CA_CRT_FILENAME" ]; then
      sed -i --follow-symlinks "s/#SSLCACertificateFile/SSLCACertificateFile/g" /container/service/apache2/assets/sites-available/registry-proxy.conf
    fi

  touch $FIRST_START_DONE
fi

echo "172.17.0.2 ldap.example.org" >> /etc/hosts

exit 0
