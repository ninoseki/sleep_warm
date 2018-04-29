require_relative "config/environment"

use Rack::SpyUp do |config|
  config.logger = Logger.new(STDOUT)
end

run SleepWarm::Application.new
