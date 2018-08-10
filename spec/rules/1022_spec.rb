describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1022)" do
    it "should log the rule id" do
      custom_request('PROPFIND', 'http://example.com/')
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ok")
      expect(last_response.header["Server"]).to eq("Microsoft-IIS/7.0")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1022)
    end
  end
end
