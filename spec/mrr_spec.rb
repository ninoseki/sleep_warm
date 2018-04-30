describe SleepWarm::MRR do

  let(:mrr) { SleepWarm::MRR.new }

  describe "#parse" do
    it "returns an array" do
      expect(mrr.rules).to be_instance_of(Array)
      mrr.rules.each do |rule|
        expect(rule.id).to be_a(Integer)
        expect(rule.enable?).to be_truthy.or be_falshy
        expect(rule.note).to be_a(String)
        expect(rule.trigger).not_to be_empty
        expect(rule.response).not_to be_empty
      end
    end
  end

  describe "#find" do
    context "input doesn't match any rule" do
      it "should return false" do
        input = { method: "NOPE", uri: "NOP" }
        res = mrr.find(input)
        expect(res).to eq(nil)
      end
    end
    context "input matches a rule" do
      it "should return true" do
        input = { method: "GET", uri: "/login" }
        res = mrr.find(input)
        expect(res).to be_a(SleepWarm::Rule)
        expect(res.response.dig("status")).to be_a(Integer)
        expect(res.response.dig("header")).to be_a(Hash)
        expect(res.response.dig("body")).to be_a(String)
      end
    end
  end
end
