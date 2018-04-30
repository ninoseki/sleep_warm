describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1018)" do
    it "should log the rule id" do
      post 'http://example.com/', "echo 2014;uname -a;w;id;echo 2015"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("2014")
      @output.rewind
      log = @output.read
      expect(log).to include("POST http://example.com/")
      expect(log).to include("1018")
    end
  end
end
