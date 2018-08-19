# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched with a rule(id = 1042)" do
    it "should log the rule id" do
      post 'http://example.com/j_security_check'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Deploying Application")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1042)
    end
  end
end
