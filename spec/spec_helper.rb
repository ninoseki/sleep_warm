require_relative '../app/config/environment'

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
    @access_log = StringIO.new
    @application_log = StringIO.new
    @hunting_log = StringIO.new
    access_logger = SleepWarm::AccessLogger.new(@access_log)
    application_logger = SleepWarm::ApplicationLogger.new(@application_log)
    hunting_logger = SleepWarm::HuntingLogger.new(@hunting_log)
    mock_app do
      use Rack::SpyUp do |mw|
        mw.access_logger = access_logger
        mw.application_logger = application_logger
      end
      use Rack::HuntUp do |mw|
        mw.hunting_logger = hunting_logger
        mw.application_logger = application_logger
      end
      run SleepWarm::Application.new
    end
  end
end

RSpec.shared_context "spyup testing", shared_context: :metadata do
  def app
    @app
  end

  def mock_app(&builder)
    @app = Rack::Builder.new(&builder)
  end

  before :all do
    @access_log = StringIO.new
    @application_log = StringIO.new
    access_logger = SleepWarm::AccessLogger.new(@access_log)
    application_logger = SleepWarm::ApplicationLogger.new(@application_log)
    mock_app do
      use Rack::SpyUp do |mw|
        mw.access_logger = access_logger
        mw.application_logger = application_logger
      end
      run SleepWarm::Application.new
    end
  end
end

RSpec.shared_context "huntup testing", shared_context: :metadata do
  def app
    @app
  end

  def mock_app(&builder)
    @app = Rack::Builder.new(&builder)
  end

  before :all do
    @hunting_log = StringIO.new
    hunting_logger = SleepWarm::HuntingLogger.new(@hunting_log)
    @application_log = StringIO.new
    application_logger = SleepWarm::ApplicationLogger.new(@application_log)
    mock_app do
      use Rack::HuntUp do |mw|
        mw.hunting_logger = hunting_logger
        mw.application_logger = application_logger
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
