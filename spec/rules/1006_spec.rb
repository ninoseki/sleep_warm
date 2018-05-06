describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1006)" do
    it "should log the rule id" do
      get 'http://example.com/robots.txt'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("User-agent")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/robots.txt")
      expect(access_log).to include("1006")
    end
  end
end
