# Sleep Warm

[![Build Status](https://travis-ci.org/ninoseki/sleep_warm.svg?branch=master)](https://travis-ci.org/ninoseki/sleep_warm)

A web-based low-interaction honeypot build on [Rack](https://github.com/rack/rack). This honeypot is highly inspired by [WOWHoneypot](https://github.com/morihisa/WOWHoneypot).

## Concepts

- Easy to install.
- Easy to customize.
- Well tested.

## Supported

- Ubuntu 16.04 LTS and Ruby 2.4.

## Installation

```sh
# install Sleep Warm
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/default.rb
# install logstash (optional)
$ itamae ssh -h HOST -u USER cookbooks/sleep_warm/logstash.rb
```

And then Sleep Warm works as `sleep-warm.service` on `9292/tcp`.

## Log

Sleep Warm outputs 2 log files.

### Access log(`/var/log/sleep-warm/access.log`)

- Access log to the honeypot.
- Grok format: `\[%{TIMESTAMP_ISO8601:hptimestamp}\] %{IP:clientip} %{URIHOST:hostname} "%{WORD:method} %{URI:uri} %{NUMBER:httpversion}" %{NUMBER:status} %{WORD:mrrid} %{GREEDYDATA:all}'`

|key|desc.|e.g.|
|---|---|---|
|hptimestamp|Timestamp of a HTTP request|`[2018-05-01T22:57:32+00:00]`|
|clientip|Client IP|`10.0.2.2`|
|hostname|Hostname|`localhost:9292`|
|method|HTTP method|`GET`|
|uri|Request URI|`http://localhost:9292`|
|httpversion|HTTP version|`HTTP/1.1`|
|status|Status code|`200`|
|mrrid|Matched rule id|`1001`|
|all|Base64 encoded HTTP request|N/A|

- e.g. `[2018-05-02T10:46:32+09:00] 127.0.0.1 localhost:9292 "GET http://localhost:9292/ HTTP/1.1" 200 None R0VUIGh0dHA6Ly9sb2NhbGhvc3Q6OTI5Mi8KQWNjZXB0LUVuY29kaW5nOiBnemlwLCBkZWZsYXRlLCBicgpBY2NlcHQtTGFuZ3VhZ2U6IGVuLGphO3E9MC45LGVuLVVTO3E9MC44CkFjY2VwdDogdGV4dC9odG1sLGFwcGxpY2F0aW9uL3hodG1sK3htbCxhcHBsaWNhdGlvbi94bWw7cT0wLjksaW1hZ2Uvd2VicCxpbWFnZS9hcG5nLCovKjtxPTAuOApDb25uZWN0aW9uOiBrZWVwLWFsaXZlCkRudDogMQpIb3N0OiBsb2NhbGhvc3Q6OTI5MgpVcGdyYWRlLUluc2VjdXJlLVJlcXVlc3RzOiAxClVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwXzEzXzQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS82NS4wLjMzMjUuMTgxIFNhZmFyaS81MzcuMzYKVmVyc2lvbjogSFRUUC8xLjE=`


### Application log(`/var/log/sleep-warm/application.log`)

- Application log of the honeypot.
