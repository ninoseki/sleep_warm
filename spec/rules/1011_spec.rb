# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1011)" do
    it "should log the rule id" do
      get 'http://example.com/wp-login.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("blog login")
      expect(last_response.header["Set-Cookie"]).to include("wordpress")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1011)
    end
  end
end
