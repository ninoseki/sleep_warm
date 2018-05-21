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

- Ubuntu 16.04 LTS and Ruby 2.4.

## Installation

### Prerequirement

You will need:

- Ruby
- [Itamae](http://itamae.kitchen/)

### How to install

```sh
$ git clone https://github.com/ninoseki/sleep_warm.git
$ cd sleep_warm
# install Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/default.rb
# install ufw and its settings for the Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/ufw.rb
# install logstash and its settings for the Sleep Warm (optional)
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/logstash.rb
```

And then the honeypot works as `sleep-warm.service` on `80/tcp` and `9292/tcp`.

## Directory structure

- `/opt/sleep-warm`: The main directory of the honeypot.
- `/var/log/sleep-warm`: The log directory of the honeypot.

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

Sleep Warm outputs 3 log files.

#### Access log(`/var/log/sleep-warm/access.log`)

- Access log to the honeypot.
- Grok format: `\[%{TIMESTAMP_ISO8601:http_timestamp}\] %{IP:client_ip} %{URIHOST:hostname} "%{WORD:method} %{URI:uri} HTTP/%{NUMBER:http_version}" %{NUMBER:status} %{WORD:rule_id} %{GREEDYDATA:all}`

|key|desc.|e.g.|
|---|---|---|
|http_timestamp|Timestamp of a HTTP request|`[2018-05-01T22:57:32+00:00]`|
|client_ip|Client IP|`10.0.2.2`|
|hostname|Hostname|`localhost:9292`|
|method|HTTP method|`GET`|
|uri|Request URI|`http://localhost:9292`|
|http_version|HTTP version|`HTTP/1.1`|
|status|Status code|`200`|
|rule_id|Matched rule id|`1001`|
|all|Base64 encoded HTTP request|-|

- e.g. `[2018-05-02T10:46:32+09:00] 127.0.0.1 localhost:9292 "GET http://localhost:9292/ HTTP/1.1" 200 None R0VUIGh0dHA6Ly9sb2NhbGhvc3Q6OTI5Mi8KQWNjZXB0LUVuY29kaW5nOiBnemlwLCBkZWZsYXRlLCBicgpBY2NlcHQtTGFuZ3VhZ2U6IGVuLGphO3E9MC45LGVuLVVTO3E9MC44CkFjY2VwdDogdGV4dC9odG1sLGFwcGxpY2F0aW9uL3hodG1sK3htbCxhcHBsaWNhdGlvbi94bWw7cT0wLjksaW1hZ2Uvd2VicCxpbWFnZS9hcG5nLCovKjtxPTAuOApDb25uZWN0aW9uOiBrZWVwLWFsaXZlCkRudDogMQpIb3N0OiBsb2NhbGhvc3Q6OTI5MgpVcGdyYWRlLUluc2VjdXJlLVJlcXVlc3RzOiAxClVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzEzXzQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS82NS4wLjMzMjUuMTgxIFNhZmFyaS81MzcuMzYKVmVyc2lvbjogSFRUUC8xLjE=`

#### Hunting log(`/var/log/sleep-warm/hunting.log`)

- Hunting log to the honeypot.
- Grok format: `\[%{TIMESTAMP_ISO8601:http_timestamp}\] %{IP:client_ip} %{GREEDYDATA:commands}`

|key|desc.|e.g.|
|---|---|---|
|http_timestamp|Timestamp of a HTTP request|`[2018-05-06T12:34:44+09:00]`|
|client_ip|Client IP|`10.0.2.2`|
|commands|Commands which try to download something|`wget http://example.com/hoge.bin`|

- e.g. `[2018-05-06T12:34:44+09:00] 10.0.2.2 wget http://example.com/hoge.bin`

#### Application log(`/var/log/sleep-warm/application.log`)

- Application log of the honeypot.

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
