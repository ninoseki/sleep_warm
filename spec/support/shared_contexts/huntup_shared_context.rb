# frozen_string_literal: true

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
