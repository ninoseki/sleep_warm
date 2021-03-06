# frozen_string_literal: true

describe SleepWarm::Hunter do
  it "returns if given an input include 'wget'" do
    hunt = subject.hunt("wget http://example.com/hoge.bin")
    expect(hunt).to be_a(Array)
    expect(hunt.length).to eq(1)
  end
end
