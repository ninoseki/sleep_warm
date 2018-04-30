require_relative '../config/environment'

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = 'default'
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "rackapp testing", shared_context: :metadata do
  def app
    @app
  end

  def mock_app(&builder)
    @app = Rack::Builder.new(&builder)
  end

  before :all do
    @output = StringIO.new
    logger = SleepWarm::Logger.new(@output)
    mock_app do
      use Rack::SpyUp do |mw|
        mw.logger = logger
      end
      run SleepWarm::Application.new
    end
  end
end

RSpec.configure do |config|
  config.include_context "rackapp testing", include_shared: true
end
