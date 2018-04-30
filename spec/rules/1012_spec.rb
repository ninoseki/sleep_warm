describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1012)" do
    it "should log the rule id" do
      get 'http://example.com/getcfg.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("DEVICE.ACCOUNT")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/getcfg.php")
      expect(log).to include("1012")
    end
  end
end
