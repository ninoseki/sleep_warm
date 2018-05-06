describe SleepWarm::Hunter do
  let(:hunter) { SleepWarm::Hunter.new }

  it "should return if given an input include 'wget'" do
    hunt = hunter.hunt("wget http://example.com/hoge.bin")
    expect(hunt).to be_a(Array)
    expect(hunt.length).to eq(1)
  end
end
