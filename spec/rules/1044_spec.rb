# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched with a rule(id = 1044)" do
    it "should log the rule id" do
      get "http://example.com/die('z!a'.'x');"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("z!ax")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1044)
    end
  end
end
