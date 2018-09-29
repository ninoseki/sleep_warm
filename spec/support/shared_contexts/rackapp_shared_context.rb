# frozen_string_literal: true

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
