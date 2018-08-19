# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched with a rule(id = 1043)" do
    it "should log the rule id" do
      post "http://example.com/whoami"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1043)
    end
  end
end
