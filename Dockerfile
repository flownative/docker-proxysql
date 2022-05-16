# -----------------------------------------------------------------------------
# ProxySQL
# Latest versions: https://proxysql.com/documentation/installing-proxysql/
#                  https://hub.docker.com/r/proxysql/proxysql/tags

ARG PROXYSQL_VERSION=2.4.1-debian
FROM proxysql/proxysql:$PROXYSQL_VERSION as proxySql

FROM europe-docker.pkg.dev/flownative/docker/base:bullseye
MAINTAINER Robert Lemke <robert@flownative.com>

ENV PROXYSQL_VERSION=$PROXYSQL_VERSION

ENV FLOWNATIVE_LIB_PATH=/opt/flownative/lib \
    PROXYSQL_BASE_PATH=/opt/flownative/proxysql \
    LOG_DEBUG=false

USER root

COPY root-files /
COPY --from=proxySql /usr/bin/proxysql ${PROXYSQL_BASE_PATH}/bin/proxysql

RUN /build.sh

USER proxysql
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "run" ]
