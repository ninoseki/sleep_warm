describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1014)" do
    it "should log the rule id" do
      post 'http://example.com/', "whoami"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")
      @output.rewind
      log = @output.read
      expect(log).to include("POST http://example.com/")
      expect(log).to include("1014")
    end
  end
end
