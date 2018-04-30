describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1040)" do
    it "should log the rule id" do
      get 'http://example.com//wls-wsat/CoordinatorPortType'
      expect(last_response.status).to eq(500)
      expect(last_response.body).to include("Web Service")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com//wls-wsat/CoordinatorPortType")
      expect(log).to include("1040")
    end
  end
end
