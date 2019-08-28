# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1006)" do
    it "logs the rule id" do
      get 'http://example.com/robots.txt'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("User-agent")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1006)
    end
  end
end
