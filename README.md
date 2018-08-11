# Sleep Warm

[![Build Status](https://travis-ci.org/ninoseki/sleep_warm.svg?branch=master)](https://travis-ci.org/ninoseki/sleep_warm)
[![Maintainability](https://api.codeclimate.com/v1/badges/46dcae2391a2a7f5dcb5/maintainability)](https://codeclimate.com/github/ninoseki/sleep_warm/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/sleep_warm/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/sleep_warm?branch=master)

A web-based low-interaction honeypot build on [Rack](https://github.com/rack/rack). This honeypot is highly inspired by [WOWHoneypot](https://github.com/morihisa/WOWHoneypot).

## Concepts

- Easy to install.
  - One-click deploy to Heroku or just execute [Itamae](http://itamae.kitchen/) scripts.
- Easy to customize.
  - Matching rules and default responses are customizable via editing YAML files.
- Well tested.

## Supported

- Ubuntu 16.04 LTS and Ruby 2.5.

## Installation

### Prerequirement

You will need an Elasticsearch instance for log analysis because Sleep Warm can only deal with Logstash logging.

### Deploy on Heroku

You can deploy Sleep Warm on Heroku by clicking the button below and follow the instructions.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/ninoseki/sleep_warm)


### Deploy by Itamae

You can automatically deploy Sleep Warm on Ubuntu by using [Itamae](http://itamae.kitchen/).

You will need Ruby 2.5 & Itamae for the auto deployment.

```sh
$ git clone https://github.com/ninoseki/sleep_warm.git
$ cd sleep_warm
# install Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/default.rb
# install ufw and its settings for the Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/ufw.rb
```

And then the honeypot works as `sleep-warm.service` on `80/tcp` and `9292/tcp`.

After the deployment, please set you Elasticsearch settings in `/opt/sleep-warm/.env` and restart the service. (By default, Sleep Warm outputs Logstash log to STDOUT.)

```
# Do not change this
RACK_ENV=production
# The hostname which Logstash sends the data for
LOGSTASH_HOST=localhost
# The port which Logstash sends the data for
LOGSTASH_PORT=9300
# (Optional) The token which Logstash send the data with.
LOGSTASH_TOKEN=YOUR_TOKEN
```

## Matching rules

Matching rules are stored in `/opt/sleep-warm/app/rules` as YAML files.

The rule file format:

```yaml
---
meta:
  id: 1001
  enable: true
  note: hoge
trigger:
  method: GET
  uri: hoge
  header: hoge
  body: hoge
response:
  status: 200
  header:
    Server: Apache/2.0.48
    Content-Type: text/html
  body: hoge
```

The rule mataches a request which  HTTP method is `GET` and request URI contains `hoge` and header contains `hoge` and body contains `hoge`.

## Log

Sleep Warm outputs 2 types of logs.

### Access log

- Access log to the honeypot.

| key          | desc.                       | e.g.                    |
|:-------------|:----------------------------|:------------------------|
| client_ip    | Client IP                   | `10.0.2.2`              |
| hostname     | Hostname                    | `localhost:9292`        |
| method       | HTTP method                 | `GET`                   |
| uri          | Request URI                 | `http://localhost:9292` |
| http_version | HTTP version                | `HTTP/1.1`              |
| status       | Status code                 | `200`                   |
| rule_id      | Matched rule id             | `1001`                  |
| all          | Base64 encoded HTTP request | -                       |

### Hunting log

- Hunting log to the honeypot.

| key       | desc.                                    | e.g.                               |
|:----------|:-----------------------------------------|:-----------------------------------|
| client_ip | Client IP                                | `10.0.2.2`                         |
| commands  | Commands which try to download something | `wget http://example.com/hoge.bin` |


