require "stringio"
require "base64"

def app
  @app
end

def mock_app(&builder)
  @app = Rack::Builder.new(&builder)
end

describe SleepWarm::Application do
  before :all do
    @output = StringIO.new
    logger = SleepWarm::Logger.new(@output)
    mock_app do
      use Rack::SpyUp do |mw|
        mw.logger = logger
      end
      run SleepWarm::Application.new
    end
  end

  context "GET with no header" do
    it "responds with a 200 OK" do
      get 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      @output.rewind
      expect(@output.read).to include("GET http://example.com")
    end
  end

  context "GET with a header" do
    it "responds with a 200 OK" do
      header "User-Agent", "Firefox"
      get 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      @output.rewind
      output = @output.read
      decoded_req = Base64.decode64(output.split.last)
      expect(decoded_req).to include("GET http://example.com")
      expect(decoded_req).to include("User-Agent: Firefox")
    end
  end

  context "POST with no payload" do
    it "responds with a 200 OK" do
      post 'http://example.com'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      @output.rewind
      output = @output.read
      decoded_req = Base64.decode64(output.split.last)
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
--AaB03x--\r
EOF
      post 'http://example.com', input
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      @output.rewind
      output = @output.read
      decoded_req = Base64.decode64(output.split.last)
      expect(decoded_req).to include("POST http://example.com")
      expect(decoded_req).to include("Content-Length: #{input.length}")
      expect(decoded_req).to include("Content-Type: application/x-www-form-urlencoded")
      expect(decoded_req).to include("foo")
    end
  end
end
