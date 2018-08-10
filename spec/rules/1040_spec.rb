describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1040)" do
    it "should log the rule id" do
      get 'http://example.com//wls-wsat/CoordinatorPortType'
      expect(last_response.status).to eq(500)
      expect(last_response.body).to include("Web Service")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1040)
    end
  end
end
