require_relative "app/config/environment"
require "dotenv/load"

def logstash_config
  ENV.select do |k, _|
    k.start_with? "LOGSTASH" && k != "LOGSTASH_HOST" && k != "LOGSTASH_PORT"
  end.map do |k, v|
    [k.split("_")[1..-1].join("_"), v]
  end.to_h
end

LogStashLogger.configure do |config|
  config.customize_event do |event|
    event["token"] = ENV["LOGSTASH_TOKEN"] if ENV.key? "LOGSTASH_TOKEN"
  end
end

logger = LogStashLogger.new(type: :tcp, host: ENV["LOGSTASH_HOST"], port: ENV["LOGSTASH_PORT"])

use Rack::SpyUp do |config|
  config.logger = logger
end

use Rack::HuntUp do |config|
  config.logger = logger
end

run SleepWarm::Application.new
