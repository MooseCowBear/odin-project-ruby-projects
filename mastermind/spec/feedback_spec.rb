require_relative "../lib/feedback.rb"

describe Feedback do
  subject(:dummy_class) { Class.new { extend Feedback } }

  describe "#feedback" do
    it "returns the correct feedback for a guess when no matches" do
      code = [1, 1, 1, 1]
      guess = [4, 4, 4, 4]
      expect(dummy_class.feedback(code, guess)).to eq ""
    end

    it "returns the correct feedback for a guess with only correct color, correct positions" do
      code = [1, 1, 1, 1]
      guess = [4, 4, 1, 1]
      expect(dummy_class.feedback(code, guess)).to eq "BB"
    end

    it "returns the correct feedback for a guess with only correct color, incorrect positions" do
      code = [1, 1, 2, 2]
      guess = [2, 3, 3, 3]
      expect(dummy_class.feedback(code, guess)).to eq "W"
    end

    it "returns the correct feedback for a guess with both correct color, correct positions and correct color, incorrect positions" do
      code = [1, 1, 2, 2]
      guess = [4, 4, 2, 1]
      expect(dummy_class.feedback(code, guess)).to eq "BW"
    end

    it "does not overcount correct color, incorrect position" do
      code = [1, 2, 2, 2]
      guess = [3, 1, 1, 1]
      expect(dummy_class.feedback(code, guess)).to eq "W"
    end

    it "does not count as correct color, incorrect position matches that have already been accounted for by correct color, correct position" do
      code = [2, 2, 2, 1]
      guess = [1, 1, 1, 1]
      expect(dummy_class.feedback(code, guess)).to eq "B"
    end
  end
end