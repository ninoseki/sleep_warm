describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1014)" do
    it "should log the rule id" do
      post 'http://example.com/', "whoami"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("POST http://example.com/")
      expect(access_log).to include("1014")
    end
  end
end
