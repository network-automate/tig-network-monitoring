# Network Monitoring with Telegraf / Influxdb / Grafana

Complete stack to monitor [Juniper](https://www.juniper.net) datacenter. it uses following components:

- [telegraf](https://www.influxdata.com/time-series-platform/telegraf/) : Agent for collecting information from devices. It can be used in 2 different flavor: `snmp` and/or [`openconfig`](http://www.openconfig.net/)
- [influxdb](https://www.influxdata.com/) : Time series database (TSN) to store all information sent by telegraf agents.
- [grafana](https://grafana.com/) : Time series analytics engine to build reports from Influxdb.

All the configuration is managed by templating for following components:

- `docker-compose` file
- `telegraf` configuration

## Quick path to demo

```shell
# Install python requirements
pip intall -r requirements.txt

# Build and start stack
make build

# Stop and delete stack
make destroy
```

Open a browser to http://127.0.0.1:9081/ with `super`/`juniper123`

## Requiremetns & Installation

As it is based on docker, you have to install docker first:

- [Centos Installation](https://docs.docker.com/install/linux/docker-ce/centos/)
- [Ubuntu Installation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [MacOS](https://docs.docker.com/docker-for-mac/install/)

Then,, you have to install python requirements

```shell
pip install -r requirements.txt
```

## Commands and usage

Define your targets by editing `data.yml` file:

### Grafana access

Access to grafna can be managed in `data.yml` file with the following section:

```yaml
grafana:
  web:
    port: "9081"
    username: "super"
    password: "juniper123"
```

> If not set, access is configured to be like: http://127.0.0.1:9081/ with username/password set to super/juniper123

### Device List
__SNMP devices__

```yaml
---
telegraf:
  snmp:
    community: "public"
    hosts:
      172.25.90.67: 161
      172.25.90.68: 161
```

__Junos Openconfig devices__

```yaml
---
telegraf:
  openconfig:
    username: 'ansible'
    password: 'juniper123'
    hosts:
      172.25.90.67: 32768
      172.25.90.68: 32768
```

> Both `snmp` and `openconfig` definition can be configure in this `data.yml`

Some commands are available to manage repository

- `make build-telegraf-conf` : Build telegraf configuration with template rendering
- `make build` : Build telegraf config, build docker-compose stack, start stack
- `make destroy` : Stop docker stack and remove containers
- `make start` : start an already configured stack. (Must be done if stack were built previously)
- `make stop` : stop running stack. Containers are not deleted and can be restarted with `make start`
- `make restart` : stop and start stack
- `make rebuild` : destroy and build stack
- `make {telegraf-snmp|telegraf-openconfig|influxdb|grafana}-cli` : connect to containers

## Components

Repository is based on docker containers and they are all managed with `docker-compose`:

- `telegraf:1.9.1` image for openconfig polling
- `inetsix/telegraf-snmp` image for SNMP polling
- `influxdb:1.7.2`
- `grafana:grafana/grafana:5.4.2`