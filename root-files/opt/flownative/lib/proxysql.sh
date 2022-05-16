#!/bin/bash
# shellcheck disable=SC1090

# =======================================================================================
# LIBRARY: PROXYSQL
# =======================================================================================

# Load helper lib

. "${FLOWNATIVE_LIB_PATH}/log.sh"
. "${FLOWNATIVE_LIB_PATH}/files.sh"
. "${FLOWNATIVE_LIB_PATH}/validation.sh"
. "${FLOWNATIVE_LIB_PATH}/process.sh"

# ---------------------------------------------------------------------------------------
# proxysql_env() - Load global environment variables for configuring ProxySQL
#
# @global PROXYSQL_* The PROXYSQL_ environment variables
# @return "export" statements which can be passed to eval()
#
proxysql_env() {
    cat <<"EOF"
export PROXYSQL_BASE_PATH="${PROXYSQL_BASE_PATH}"
export PROXYSQL_CONF_PATH="${PROXYSQL_BASE_PATH}/etc"
export PROXYSQL_DATA_PATH="${PROXYSQL_BASE_PATH}/var"

export PROXYSQL_USER_USERNAME=${PROXYSQL_USER_USERNAME:-}
export PROXYSQL_USER_PASSWORD=${PROXYSQL_USER_PASSWORD:-}

export PROXYSQL_SERVERS_1_HOST=${PROXYSQL_SERVERS_1_HOST:-}
export PROXYSQL_SERVERS_2_HOST=${PROXYSQL_SERVERS_2_HOST:-}
export PROXYSQL_SERVERS_3_HOST=${PROXYSQL_SERVERS_3_HOST:-}

export PROXYSQL_SERVERS_1_PORT=${PROXYSQL_SERVERS_1_PORT:-3306}
export PROXYSQL_SERVERS_2_PORT=${PROXYSQL_SERVERS_2_PORT:-3306}
export PROXYSQL_SERVERS_3_PORT=${PROXYSQL_SERVERS_3_PORT:-3306}

export PROXYSQL_SERVERS_1_MAX_CONNECTIONS=${PROXYSQL_SERVERS_1_MAX_CONNECTIONS:-1000}
export PROXYSQL_SERVERS_2_MAX_CONNECTIONS=${PROXYSQL_SERVERS_2_MAX_CONNECTIONS:-1000}
export PROXYSQL_SERVERS_3_MAX_CONNECTIONS=${PROXYSQL_SERVERS_3_MAX_CONNECTIONS:-1000}

export PATH="${PATH}:${PROXYSQL_BASE_PATH}/bin"
EOF
}

# ---------------------------------------------------------------------------------------
# proxysql_initialize() - Initialize ProxySQL configuration
#
# @global PROXYSQL_* The PROXYSQL_* environment variables
# @return void
#
proxysql_initialize() {
    info "ProxySQL: Initializing ..."

    envsubst < "${PROXYSQL_CONF_PATH}/proxysql.conf.template" > "${PROXYSQL_CONF_PATH}/proxysql.conf"
}
