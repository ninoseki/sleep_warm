describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1036)" do
    it "should log the rule id" do
      get 'http://example.com/cmx.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("CMD2017")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/cmx.php")
      expect(access_log).to include("1036")
    end
  end
end
