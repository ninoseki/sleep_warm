describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1010)" do
    it "should log the rule id" do
      header "User-Agent", "echo 2014 | md5sum"
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("ad43fd99987a8f6a648abe05095bf52c")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1010)
    end
  end
end
