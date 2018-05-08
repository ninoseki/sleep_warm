describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1013)" do
    it "should log the rule id" do
      header "User-Agent", "whoami"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/")
      expect(access_log).to include("1013")
    end
  end
end
