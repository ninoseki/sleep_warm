describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1005)" do
    it "should log the rule id" do
      put 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("file created.")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("PUT http://example.com/")
      expect(access_log).to include("1005")
    end
  end
end
