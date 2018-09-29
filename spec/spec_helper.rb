# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

require 'rack/test'

require_relative '../app/config/environment'
require_relative "./support/helpers/helpers"

require_relative "./support/shared_contexts/huntup_shared_context"
require_relative "./support/shared_contexts/rackapp_shared_context"
require_relative "./support/shared_contexts/spyup_shared_context"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spec::Support::Helpers
  config.order = 'default'
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before do
    allow($stdout).to receive(:puts)
  end

  config.include_context "rackapp testing", include_shared: true
  config.include_context "spyup testing", include_shared: true
  config.include_context "huntup testing", include_shared: true
end
