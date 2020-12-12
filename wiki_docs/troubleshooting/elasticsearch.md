# Elasticsearch

## Elasticsearch 6.x

```bash
ERROR: [1] bootstrap checks failed
[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
```

### possible solutions

Set `vm.max_map_count` to at least `262144`

The `vm.max_map_count` kernel setting must be set to at least `262144` for production use.

How you set `vm.max_map_count` depends on your platform:

## Linux

The `vm.max_map_count` setting should be set permanently in `/etc/sysctl.conf`:

```bash
grep vm.max_map_count /etc/sysctl.conf
vm.max_map_count=262144
```

To apply the setting on a live system, run:

```bash
sysctl -w vm.max_map_count=262144
```
-------------------

## macOS with [Docker for Mac](https://docs.docker.com/docker-for-mac)

The `vm.max_map_count` setting must be set within the xhyve virtual machine:

- From the command line, run:


```bash
screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
```

- Press enter and use`sysctl` to configure `vm.max_map_count`:


```bash
sysctl -w vm.max_map_count=262144
```


### Ref. [elasticseearch docs.](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-prod-prerequisites)

-------------

## Elasticsearch 7.x

### command **warp ps**

```bash
<project-name>_elasticsearch_1   /usr/local/bin/docker-entr ...   Exit 78
```

### command **warp logs elasticsearch**

_Native controller process has stopped_

```bash
elasticsearch_1  | {"type": "server", "timestamp": "2020-07-08T21:14:26,575Z", "level": "INFO", "component": "o.e.x.m.p.NativeController", "cluster.name": "docker-cluster", "node.name": "7ba16b86247e", "message": "Native controller process has stopped - no new native processes can be started" }
```

### possible solutions

Check if you have environment variable `discovery.type` inside the file `docker-compose-warp.yml.sample` in **elasticsearch** service, like this:

```yaml
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms${ES_MEMORY} -Xmx${ES_MEMORY}"
```

If you don't have that setting you need to add it and follow these steps:

- warp stop --hard
- add `- discovery.type=single-node` at the file `docker-compose-warp.yml.sample`
- warp reset
- warp init
- warp start

-------------