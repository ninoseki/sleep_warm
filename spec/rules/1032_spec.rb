describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1032)" do
    it "should log the rule id" do
      get 'http://example.com/manager/html'
      expect(last_response.status).to eq(401)
      expect(last_response.body).to include("401")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["WWW-Authenticate"]).to eq('Basic realm="Tomcat Manager Application"')
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/manager/html")
      expect(log).to include("1032")
    end
  end
end
