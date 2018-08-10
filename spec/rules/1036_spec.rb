describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1036)" do
    it "should log the rule id" do
      get 'http://example.com/cmx.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("CMD2017")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1036)
    end
  end
end
