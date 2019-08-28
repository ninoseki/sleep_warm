# frozen_string_literal: true

describe SleepWarm::Application do
  include_context "spyup testing"

  context "Request which is matched a rule(id = 1034)" do
    it "logs the rule id" do
      header "User-Agent", "dG9tY2F0OnBhc3N3b3JkCg=="
      get 'http://example.com/manager/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("tomcat")
      expect(last_response.header["Server"]).to eq("Apache-Coyote/1.1")
      expect(last_response.header["Expires"]).to eq("Thu, 01 Jan 1970 00:00:00 GMT")
      expect(last_response.header["Set-Cookie"]).to eq("JSESSIONID=93F0540DD116537763C29FDF67102DCF")

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["rule_id"]).to eq(1034)
    end
  end
end
