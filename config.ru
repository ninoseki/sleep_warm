require_relative "config/environment"
require "dotenv/load"

use Rack::SpyUp do |config|
  config.logger = SleepWarm::Logger.new(ENV["ACCESS_LOG"] || STDOUT)
end

run SleepWarm::Application.new
