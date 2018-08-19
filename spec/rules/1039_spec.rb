# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1039)" do
    it "should log the rule id" do
      get 'http://example.com/wp-config.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("WordPress")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1039)
    end
  end
end
