describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1002)" do
    it "should log the rule id" do
      post 'http://example.com/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("login failed.")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1002)
    end
  end
end
