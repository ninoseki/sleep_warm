describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1031)" do
    it "should log the rule id" do
      get 'http://example.com/manager/status'
      expect(last_response.status).to eq(401)
      expect(last_response.body).to include("401")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["WWW-Authenticate"]).to eq('Basic realm="Tomcat Manager Application"')
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/manager/status")
      expect(log).to include("1031")
    end
  end
end