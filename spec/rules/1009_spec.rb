describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1009)" do
    it "should log the rule id" do
      header "User-Agent", "Struts2045"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Struts2045")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/")
      expect(log).to include("1009")
    end
  end
end
