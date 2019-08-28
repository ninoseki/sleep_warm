# frozen_string_literal: true

describe SleepWarm::MRR do
  describe "#parse" do
    it "returns an Array" do
      expect(subject.rules).to be_instance_of(Array)
      subject.rules.each do |rule|
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
      it "returns false" do
        input = { method: "NOPE", uri: "NOP" }
        res = subject.find(input)
        expect(res).to eq(nil)
      end
    end

    context "input matches a rule" do
      it "returns true" do
        input = { method: "GET", uri: "/login" }
        res = subject.find(input)
        expect(res).to be_a(SleepWarm::Rule)
        expect(res.response.dig("status")).to be_a(Integer)
        expect(res.response.dig("header")).to be_a(Hash)
        expect(res.response.dig("body")).to be_a(String)
      end
    end
  end
end
