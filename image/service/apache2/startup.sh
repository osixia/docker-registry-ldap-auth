#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

ln -s ${CONTAINER_SERVICE_DIR}/apache2/assets/conf-available/registry-proxy.conf /etc/apache2/conf-available/registry-proxy.conf
ln -s ${CONTAINER_SERVICE_DIR}/apache2/assets/sites-available/registry-proxy.conf /etc/apache2/sites-available/registry-proxy.conf

a2enconf registry-proxy
a2ensite registry-proxy

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-registry-ldap-auth-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

    # check certificat and key or create it
    cfssl-helper ${REGISTRY_LDAP_AUTH_CFSSL_PREFIX} "${CONTAINER_SERVICE_DIR}/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_CRT_FILENAME" "${CONTAINER_SERVICE_DIR}/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_KEY_FILENAME" "${CONTAINER_SERVICE_DIR}/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_CA_CRT_FILENAME"

    # add CA certificat config if CA cert exists
    if [ -e "${CONTAINER_SERVICE_DIR}/apache2/assets/certs/$REGISTRY_LDAP_AUTH_HTTPS_CA_CRT_FILENAME" ]; then
      sed -i "s/#SSLCACertificateFile/SSLCACertificateFile/g" ${CONTAINER_SERVICE_DIR}/apache2/assets/sites-available/registry-proxy.conf
    fi

  touch $FIRST_START_DONE
fi

exit 0
