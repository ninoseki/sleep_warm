describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1039)" do
    it "should log the rule id" do
      get 'http://example.com/wp-config.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("WordPress")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/wp-config.php")
      expect(access_log).to include("1039")
    end
  end
end
