describe SleepWarm::Application do
  include_context "rackapp testing"

  context "Request which is matched a rule(id = 1021)" do
    it "should log the rule id" do
      get 'http://example.com/diZPqEAuJM.jsp'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("42d388f8b1db997faaf7dab487f11290")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      @output.rewind
      log = @output.read
      expect(log).to include("GET http://example.com/diZPqEAuJM.jsp")
      expect(log).to include("1021")
    end
  end
end
