describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1034)" do
    it "should log the rule id" do
      header "User-Agent", "dG9tY2F0OnBhc3N3b3JkCg=="
      get 'http://example.com/manager/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("tomcat")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["Expires"]).to eq("Thu, 01 Jan 1970 00:00:00 GMT")
      expect(last_response.header["Set-Cookie"]).to eq("JSESSIONID=93F0540DD116537763C29FDF67102DCF")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/manager/")
      expect(access_log).to include("1034")
    end
  end
end
