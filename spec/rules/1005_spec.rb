# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1005)" do
    it "logs the rule id" do
      put 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("file created.")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1005)
    end
  end
end
