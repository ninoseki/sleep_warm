describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1020)" do
    it "should log the rule id" do
      get 'http://example.com/test.jsp'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ok")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com/")
      expect(access_log).to include("1020")
    end
  end
end
