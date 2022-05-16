#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

useradd --home-dir "${PROXYSQL_BASE_PATH}" --no-create-home --no-user-group --uid 1000 proxysql
groupadd --gid 1000 proxysql

mkdir -p \
    "${PROXYSQL_BASE_PATH}/etc" \
    "${PROXYSQL_BASE_PATH}/bin" \
    "${PROXYSQL_BASE_PATH}/var"

chown -R proxysql:proxysql "${PROXYSQL_BASE_PATH}"
chmod -R g+rwX "${PROXYSQL_BASE_PATH}"
chmod 664 "${PROXYSQL_BASE_PATH}"/etc/*

chmod -R g+rwX "${PROXYSQL_BASE_PATH}"

# We don't need logrotate in this image:
rm -f /opt/flownative/supervisor/etc/conf.d/logrotate.conf
