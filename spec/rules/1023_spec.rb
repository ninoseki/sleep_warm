describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1023)" do
    it "should log the rule id" do
      get 'http://example.com/setup.cgi'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ok")
      expect(last_response.header["WWW-Authenticate"]).to eq("DGN1000")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/setup.cgi")
      expect(access_log).to include("1023")
    end
  end
end
