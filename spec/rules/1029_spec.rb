# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1029)" do
    it "logs the rule id" do
      get 'http://example.com/jmx-console/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("JBoss")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["X-Powered-By"]).to eq('Servlet/3.0; JBossAS-6')

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1029)
    end
  end
end
