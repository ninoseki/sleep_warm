describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1016)" do
    it "should log the rule id" do
      post 'http://example.com/', "/etc/passwd"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("root")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("POST http://example.com/")
      expect(access_log).to include("1016")
    end
  end
end
