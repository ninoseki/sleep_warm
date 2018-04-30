describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1027)" do
    it "should log the rule id" do
      get 'http://example.com/axis2'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("JBoss")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["X-Powered-By"]).to eq('Servlet/3.0; JBossAS-6')
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/axis2")
      expect(access_log).to include("1027")
    end
  end
end
