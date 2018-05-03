describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1017)" do
    it "should log the rule id" do
      header "User-Agent", "echo 2014;uname -a;w;id;echo 2015"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("2014")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/")
      expect(access_log).to include("1017")
    end
  end
end
