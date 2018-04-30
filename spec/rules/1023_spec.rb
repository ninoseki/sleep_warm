describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1023)" do
    it "should log the rule id" do
      get 'http://example.com/setup.cgi'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ok")
      expect(last_response.header["WWW-Authenticate"]).to eq("DGN1000")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/setup.cgi")
      expect(log).to include("1023")
    end
  end
end
