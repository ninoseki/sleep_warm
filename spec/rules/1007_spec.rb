describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1007)" do
    it "should log the rule id" do
      get 'http://example.com/phpMyAdmin/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("phpmyadmin")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/phpMyAdmin/")
      expect(access_log).to include("1007")
    end
  end
end
