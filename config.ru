require_relative "config/environment"

use Rack::SpyUp do |config|
  config.logger = SleepWarm::Logger.new(STDOUT)
end

run SleepWarm::Application.new
