# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1032)" do
    it "logs the rule id" do
      get 'http://example.com/manager/html'
      expect(last_response.status).to eq(401)
      expect(last_response.body).to include("401")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["WWW-Authenticate"]).to eq('Basic realm="Tomcat Manager Application"')

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1032)
    end
  end
end
