describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1016)" do
    it "should log the rule id" do
      post 'http://example.com/', "/etc/passwd"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1016)
    end
  end
end
