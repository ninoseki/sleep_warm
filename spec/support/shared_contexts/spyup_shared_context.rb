# frozen_string_literal: true

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
