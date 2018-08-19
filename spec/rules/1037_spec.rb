# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1037)" do
    it "should log the rule id" do
      post 'http://example.com/', "pi%28%29%2A42"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("131.94689145077")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1037)
    end
  end
end
