# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1041)" do
    it "should log the rule id" do
      post 'http://example.com/wls-wsat/CoordinatorPortType'
      expect(last_response.status).to eq(500)
      expect(last_response.body).to include("xml")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1041)
    end
  end
end
