describe SleepWarm::MRR do
  describe "#parse" do
    it "returns an array" do
      mrr = SleepWarm::MRR.new

      expect(mrr.rules).to be_instance_of(Array)
      mrr.rules.each do |rule|
        expect(rule.dig("meta")).not_to be_empty
        expect(rule.dig("trigger")).not_to be_empty
        expect(rule.dig("response")).not_to be_empty
      end
    end
  end
end
