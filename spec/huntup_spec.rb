describe SleepWarm::Application do
  include_context "huntup testing"

  context "GET with no header" do
    it "responds with a 200 OK" do
      post 'http://example.com/', "wget http://example.com/bin/"
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_empty
    end
  end
end
