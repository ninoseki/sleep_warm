describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1037)" do
    it "should log the rule id" do
      post 'http://example.com/', "pi%28%29%2A42"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("131.94689145077")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("POST http://example.com/")
      expect(access_log).to include("1037")
    end
  end
end
