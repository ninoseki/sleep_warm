describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1002)" do
    it "should log the rule id" do
      post 'http://example.com/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("login failed.")
      @output.rewind
      log = @output.read
      expect(log).to include("POST http://example.com/login")
      expect(log).to include("1002")
    end
  end
end
