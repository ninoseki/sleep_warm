describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1008)" do
    it "should log the rule id" do
      post 'http://example.com/command.php'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("610cker")
      @output.rewind
      log = @output.read
      expect(log).to include("POST http://example.com/command.php")
      expect(log).to include("1008")
    end
  end
end
