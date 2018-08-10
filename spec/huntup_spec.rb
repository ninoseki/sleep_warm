describe SleepWarm::Application do
  include_context "huntup testing"

  context "POST with wget" do
    it "responds with a 200 OK" do
      post 'http://example.com/', "wget http://example.com/hoge.bin"
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty

      queue = io_to_queue(@huntup_log)
      log = queue.last
      expect(log["hits"]).to include("wget http://example.com/hoge.bin")
    end
  end
end
