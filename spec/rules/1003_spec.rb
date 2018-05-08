describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1003)" do
    it "should log the rule id" do
      head 'http://example.com/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("HEAD http://example.com/login")
      expect(access_log).to include("1003")
    end
  end
end
