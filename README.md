# Sleep Warm

[![Build Status](https://travis-ci.org/ninoseki/sleep_warm.svg?branch=master)](https://travis-ci.org/ninoseki/sleep_warm)
[![Maintainability](https://api.codeclimate.com/v1/badges/46dcae2391a2a7f5dcb5/maintainability)](https://codeclimate.com/github/ninoseki/sleep_warm/maintainability)

A web-based low-interaction honeypot build on [Rack](https://github.com/rack/rack). This honeypot is highly inspired by [WOWHoneypot](https://github.com/morihisa/WOWHoneypot).

## Concepts

- Easy to install.
  - Just execute [Itamae](http://itamae.kitchen/) scripts.
- Easy to customize.
  - Matching rules and default responses are customizable via editing YAML files.
- Well tested.

## Supported

- Ubuntu 16.04 LTS and Ruby 2.5.

## Installation

### Prerequirement

You will need:

- Ruby
- [Itamae](http://itamae.kitchen/)
- An ELK stack for log analysis
  -

### How to install

```sh
$ git clone https://github.com/ninoseki/sleep_warm.git
$ cd sleep_warm
# install Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/default.rb
# install ufw and its settings for the Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/ufw.rb
```

And then the honeypot works as `sleep-warm.service` on `80/tcp` and `9292/tcp`.

## Directory structure

- `/opt/sleep-warm`: The main directory of the honeypot.

### Matching rules

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

### Log

Sleep Warm outputs 3 types of logs.

#### Access log

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

#### Hunting log

- Hunting log to the honeypot.

| key       | desc.                                    | e.g.                               |
|:----------|:-----------------------------------------|:-----------------------------------|
| client_ip | Client IP                                | `10.0.2.2`                         |
| commands  | Commands which try to download something | `wget http://example.com/hoge.bin` |


## Default UFW settings

```sh
ufw default DENY
ufw allow 80/tcp
ufw allow 9292/tcp
ufw allow 22/tcp
ufw allow 2222/tcp
```

```sh
# /etc/ufw/before.rules
....
*nat
:PREROUTING ACCEPT [0:0]
-A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 9292
COMMIT

*filter
:ufw-before-input - [0:0]
:ufw-before-output - [0:0]
:ufw-before-forward - [0:0]
:ufw-not-local - [0:0]
....
```
