describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1037)" do
    it "should log the rule id" do
      post 'http://example.com/', "pi%28%29%2A42"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("131.94689145077")
      @output.rewind
      log = @output.read
      expect(log).to include("POST http://example.com/")
      expect(log).to include("1037")
    end
  end
end
