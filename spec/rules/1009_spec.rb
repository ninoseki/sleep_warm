describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1009)" do
    it "should log the rule id" do
      header "User-Agent", "Struts2045"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Struts2045")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/")
      expect(access_log).to include("1009")
    end
  end
end
