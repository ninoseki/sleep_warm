describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1041)" do
    it "should log the rule id" do
      post 'http://example.com/wls-wsat/CoordinatorPortType'
      expect(last_response.status).to eq(500)
      expect(last_response.body).to include("xml")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("POST http://example.com/wls-wsat/CoordinatorPortType")
      expect(access_log).to include("1041")
    end
  end
end
