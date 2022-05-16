[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Maintenance level: Acquaintance](https://img.shields.io/badge/maintenance-%E2%99%A1-ff69b4.svg)](https://www.flownative.com/en/products/open-source.html)
![Nightly Builds](https://github.com/flownative/docker-proxysql/workflows/Nightly%20Builds/badge.svg)
![Release to Docker Registries](https://github.com/flownative/docker-proxysql/workflows/Release%20to%20Docker%20Registries/badge.svg)

# Flownative ProxySQL Image

A Docker image providing [ProxySQL](https://proxysql.com/) for [Beach](https://www.flownative.com/beach),
[Local Beach](https://www.flownative.com/localbeach) and other purposes. Compared to the
official ProxySQL image, this one provides an opinionated configuration which can be
controlled through environment variables.

## Usage

While ProxySQL offers a plethora of features, this image is intended to just replace a connection based
on a single MariaDB host with one connecting to three different host names of a Galera cluster.

In Local Beach, this would be achieved by adding the following container to `.localbeach-docker-compose.yaml`:

```yaml
  proxysql:
    image: flownative/proxysql:dev
    ports:
      - "3306"
    networks:
      - local_beach
    environment:
      - PROXYSQL_USER_USERNAME=${BEACH_DATABASE_USERNAME}
      - PROXYSQL_USER_PASSWORD=${BEACH_DATABASE_PASSWORD}
      - PROXYSQL_SERVERS_1_HOST=local_beach_database.local_beach
      - PROXYSQL_SERVERS_2_HOST=local_beach_database.local_beach
      - PROXYSQL_SERVERS_3_HOST=local_beach_database.local_beach
…
```

When the container configuration is in place, you can switch the database host configured for Flow / Neos
to ProxySQL by overriding the respective variable in your `.localbeach.dist.env`:

```yaml
BEACH_DATABASE_HOST=proxysql
```

Flow will now use ProxySQL instead of connecting to the database directly (you can test that by stopping and
starting the proxysql container with `docker stop` and `docker start`).

Note that the above example only connects to one database server (and thus doesn't make sense). In a real
scenario, you'd provide 3 distinct host names for `PROXYSQL_SERVERS_1_HOST`, `PROXYSQL_SERVERS_2_HOST` and
`PROXYSQL_SERVERS_3_HOST`. ProxySQL will then balance connections between the specified hosts.ProxySQL.

ProxySQL needs a username and password of a MariaDB user (likely the one you used previously, while connecting
to MariaDB directly), in order to open connections to the Galera cluster and to monitor the specified hosts.
If one or more hosts don't respond, ProxySQL will route queries to healthy hosts only until the failing host
are operational again.

### Environment variables

| Variable Name           | Type   | Default                               | Description                                                    |
| ----------------------- | ------ | ------------------------------------- | -------------------------------------------------------------- |
| PROXYSQL_USER_USERNAME  | string |                                       | Username of a MariaDB user used for connections and monitoring |
| PROXYSQL_USER_PASSWORD  | string |                                       | Password of a MariaDB user used for connections and monitoring |
| PROXYSQL_SERVERS_1_HOST | string | First host of the MariaDB host group  |                                                                |
| PROXYSQL_SERVERS_2_HOST | string | Second host of the MariaDB host group |                                                                |
| PROXYSQL_SERVERS_3_HOST | string | Third host of the MariaDB host group  |                                                                |

## Further reading

- https://proxysql.com/documentation/galera-configuration/
- https://proxysql.com/blog/proxysql-native-galera-support/

## Security aspects

This image is designed to run as a non-root container. When you are running
this image with Docker or in a Kubernetes context, you can take advantage
of the non-root approach by disallowing privilege escalation:

```yaml
$ docker run flownative/proxysql:latest --security-opt=no-new-privileges
```

The administration backend – usually accessible via port 6032 – has been configured to only listen
to 127.0.0.1 so that it cannot be reached from outside the container.
