# Warp Engine

## Overview


```bash
  ___ ____     ____        _____
 ____      ___      ______      ___
      _  ___  __    ___        ____
 ___ | |     / /___ __________       ____
     | | /| / / __ `/ ___/ __ \ __    ___
 ___ | |/ |/ / /_/ / /  / /_/ / __  ___
 _   |__/|__/\__,_/_/  / .___/    ___   ____
  __   ___    ____    /_/  ___   __   __
      ____     ___   ____  __   ______
 ____      ___      ______    ____   ____

 WARP ENGINE - Speeding up! your development infraestructure
```


## Features

* Nginx
* PHP
* MySQL
* Rabbit
* MailHog
* Elasticsearch
* Varnish
* Selenium
* PostgreSQL

## Requirements

* Docker community edition
* docker-compose


## Installation

Run the following command in your root project folder:

```bash
curl -u "bestworlds:Sail7Seas" -L -o warp https://packages.bestworlds.com/warp-engine/release/latest && chmod 755 warp
```

## Command line update

Run the following command in your root project folder:

```bash
curl -u "bestworlds:Sail7Seas" -L -o warp https://packages.bestworlds.com/warp-engine/release/latest && chmod 755 warp && ./warp update
```

## Getting started

After download the warp binary file, you should initialize your dockerized infraestrucutre running the following command:

```bash
./warp init	
```

## Useful warp commands

This repo comes with some useful bash command:

|  Command  |  Description  |
|  -------  |  -----------  |
| **warp --help** | Shows the warp tool help |
| **warp [command] --help** | Shows the specific command help. For instance: warp php --help |
| **warp info** | Shows the configured values and useful information for each services |
| **warp init** |  Initialize the warp framework the first time before to start the project |
| **warp start** | Starts the containers |
| **warp stop** | Stops the containers |
| **warp reset** | Reset config to default |
| **warp fix** | fix common problems with permissions |

## Changelog

### See what has changed: [changes](https://github.com/Best-Worlds/warp-engine/blob/master/CHANGES.md)

