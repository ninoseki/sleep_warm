describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1004)" do
    it "should log the rule id" do
      options 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      expect(last_response.header["Allow"]).to eq("GET,HEAD,POST,PUT,OPTIONS,CONNECT,PROPFIND")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1004)
    end
  end
end
