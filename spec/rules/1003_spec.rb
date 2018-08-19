# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1003)" do
    it "should log the rule id" do
      head 'http://example.com/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1003)
    end
  end
end
