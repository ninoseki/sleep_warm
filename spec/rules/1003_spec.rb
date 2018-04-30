describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1003)" do
    it "should log the rule id" do
      head 'http://example.com/login'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      @output.rewind
      log = @output.read
      expect(log).to include("HEAD http://example.com/login")
      expect(log).to include("1003")
    end
  end
end
