describe SleepWarm::Hunter do
  it "should return if given an input include 'wget'" do
    hunt = subject.hunt("wget http://example.com/hoge.bin")
    expect(hunt).to be_a(Array)
    expect(hunt.length).to eq(1)
  end
end
