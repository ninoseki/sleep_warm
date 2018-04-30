describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1035)" do
    it "should log the rule id" do
      header "User-Agent", "echo linux--2017"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("linux--2017")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/")
      expect(log).to include("1035")
    end
  end
end
