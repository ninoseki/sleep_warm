# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1013)" do
    it "logs the rule id" do
      header "User-Agent", "whoami"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1013)
    end
  end
end
