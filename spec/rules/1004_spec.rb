describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1004)" do
    it "should log the rule id" do
      options 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      expect(last_response.header["Allow"]).to eq("GET,HEAD,POST,PUT,OPTIONS,CONNECT,PROPFIND")

      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("OPTIONS http://example.com/")
      expect(access_log).to include("1004")
    end
  end
end
