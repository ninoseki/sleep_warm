describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1020)" do
    it "should log the rule id" do
      get 'http://example.com/test.jsp'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ok")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1020)
    end
  end
end
