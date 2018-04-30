describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1022)" do
    it "should log the rule id" do
      custom_request('PROPFIND', 'http://example.com/')
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ok")
      expect(last_response.header["Server"]).to eq("Microsoft-IIS/7.0")
      @output.rewind
      log = @output.read
      expect(log).to include("PROPFIND http://example.com/")
      expect(log).to include("1022")
    end
  end
end
