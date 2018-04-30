require_relative "config/environment"
require "dotenv/load"

use Rack::SpyUp do |config|
  config.access_logger = SleepWarm::AccessLogger.new(ENV["ACCESS_LOG"] || STDOUT)
  config.application_logger = SleepWarm::ApplicationLogger.new(ENV["APPLICATION_LOG"] || STDOUT)
end

run SleepWarm::Application.new
