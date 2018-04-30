describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1019)" do
    it "should log the rule id" do
      get 'http://example.com/etc/passwd'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/etc/passwd")
      expect(log).to include("1019")
    end
  end
end
