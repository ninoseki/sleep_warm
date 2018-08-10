require_relative '../app/config/environment'
require 'helpers'

require 'rack/test'

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Helpers
  config.order = 'default'
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Suppress STDOUT output
RSpec.configure do |config|
  config.before do
    allow($stdout).to receive(:puts)
  end
end

def app
  @app
end

def mock_app(&builder)
  @app = Rack::Builder.new(&builder)
end

RSpec.shared_context "rackapp testing", shared_context: :metadata do
  before :all do
    @spyup_log = StringIO.new
    spyup_logger = LogStashLogger.new(type: :io, io: @spyup_log)

    @huntup_log = StringIO.new
    huntup_logger = LogStashLogger.new(type: :io, io: @huntup_log)

    mock_app do
      use Rack::SpyUp do |mw|
        mw.logger = spyup_logger
      end
      use Rack::HuntUp do |mw|
        mw.logger = huntup_logger
      end
      run SleepWarm::Application.new
    end
  end
end

RSpec.shared_context "spyup testing", shared_context: :metadata do
  before :all do
    @spyup_log = StringIO.new
    spyup_logger = LogStashLogger.new(type: :io, io: @spyup_log)

    mock_app do
      use Rack::SpyUp do |mw|
        mw.logger = spyup_logger
      end
      run SleepWarm::Application.new
    end
  end
end

RSpec.shared_context "huntup testing", shared_context: :metadata do
  before :all do
    @huntup_log = StringIO.new
    huntup_logger = LogStashLogger.new(type: :io, io: @huntup_log)

    mock_app do
      use Rack::HuntUp do |mw|
        mw.logger = huntup_logger
      end
      run SleepWarm::Application.new
    end
  end
end

RSpec.configure do |config|
  config.include_context "rackapp testing", include_shared: true
  config.include_context "spyup testing", include_shared: true
  config.include_context "huntup testing", include_shared: true
end
