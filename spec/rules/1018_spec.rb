describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1018)" do
    it "should log the rule id" do
      post 'http://example.com/', "echo 2014;uname -a;w;id;echo 2015"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("2014")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1018)
    end
  end
end
