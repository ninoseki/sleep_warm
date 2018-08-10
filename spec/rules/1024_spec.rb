describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1024)" do
    it "should log the rule id" do
      post 'http://example.com/', "getcfg/DEVICE.ACCOUNT.xml"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("DEVICE.ACCOUNT")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1024)
    end
  end
end
