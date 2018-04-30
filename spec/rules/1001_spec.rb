describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1001)" do
    it "should log the rule id" do
      get 'http://example.com/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/login")
      expect(log).to include("1001")
    end
  end
end
