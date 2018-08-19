# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1012)" do
    it "should log the rule id" do
      get 'http://example.com/getcfg.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("DEVICE.ACCOUNT")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1012)
    end
  end
end
