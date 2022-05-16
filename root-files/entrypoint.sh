#!/bin/bash
# shellcheck disable=SC1090

set -o errexit
set -o nounset
set -o pipefail

. "${FLOWNATIVE_LIB_PATH}/supervisor.sh"
. "${FLOWNATIVE_LIB_PATH}/banner.sh"
. "${FLOWNATIVE_LIB_PATH}/proxysql.sh"

eval "$(proxysql_env)"
eval "$(supervisor_env)"

banner_flownative "ProxySQL"

proxysql_initialize

supervisor_initialize
supervisor_start

trap 'supervisor_stop' SIGINT SIGTERM

if [[ "$*" = *"run"* ]]; then
    supervisor_pid=$(supervisor_get_pid)
    info "Entrypoint: Start up complete"
    # We can't use "wait" because supervisord is not a direct child of this shell:
    while [ -e "/proc/${supervisor_pid}" ]; do sleep 1.1; done
    info "Good bye 👋"
else
    "$@"
fi
