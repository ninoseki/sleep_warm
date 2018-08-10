require_relative "app/config/environment"
require "dotenv/load"

def has_logstash_settings?
  ENV.key?("LOGSTASH_HOST") && ENV.key?("LOGSTASH_PORT")
end

if has_logstash_settings?
  logger = LogStashLogger.new(type: :tcp, host: ENV["LOGSTASH_HOST"], port: ENV["LOGSTASH_PORT"])
  LogStashLogger.configure do |config|
    config.customize_event do |event|
      event["token"] = ENV["LOGSTASH_TOKEN"] if ENV.key? "LOGSTASH_TOKEN"
    end
  end
else
  logger = LogStashLogger.new(type: :stdout)
end

use Rack::SpyUp do |config|
  config.logger = logger
end

use Rack::HuntUp do |config|
  config.logger = logger
end

run SleepWarm::Application.new
