describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1006)" do
    it "should log the rule id" do
      get 'http://example.com/robots.txt'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("User-agent")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/robots.txt")
      expect(log).to include("1006")
    end
  end
end
