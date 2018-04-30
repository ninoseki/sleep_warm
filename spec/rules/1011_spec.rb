describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1011)" do
    it "should log the rule id" do
      get 'http://example.com/wp-login.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("blog login")
      expect(last_response.header["Set-Cookie"]).to include("wordpress")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/wp-login.php")
      expect(log).to include("1011")
    end
  end
end
