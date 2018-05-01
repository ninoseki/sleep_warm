# Sleep Warm

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

- `/var/log/sleep-warm/access.log`
  - Access log to the honeypot.
  - Format: `\[%{TIMESTAMP_ISO8601:hptimestamp}\] %{IP:clientip} %{URIHOST:hostname} "%{WORD:method} %{URIPATHPARAM:uri} %{NUMBER:httpversion}" %{NUMBER:status} %{WORD:mrrid} %{GREEDYDATA:all}'`

|key|desc.|e.g.|
|---|---|
|hptimestamp|Timestamp of a HTTP request|`[2018-05-01 06:39:41 +0000]`|
|clientip|Client IP|`10.0.2.2`|
|hostname|Hostname|`localhost:9292`|
|method|HTTP method|`GET`|
|uri|Request URI|`http://localhost:9292`|
|httpversion|Version of HTTP|`1.1`|
|status|Status code|`200`|
|mrrid|Matched rule id|`1001`|
|all|Base64 encoded HTTP request||

- `/var/log/sleep-warm/application.log`:
