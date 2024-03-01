require_relative '../lib/human_player.rb'

describe HumanPlayer do
  subject(:test_player) { described_class.new("Sally") }

  describe "#make_guess" do
    it "returns valid string converted to array of ints" do
      arg = double()
      allow($stdout).to receive(:puts) # so won't print message in test
      allow($stdin).to receive(:gets).and_return("1111")
      expect(test_player.make_guess(arg)).to match_array([1, 1, 1, 1])
    end

    it "returns the first valid input provided" do
      arg = double()
      allow($stdout).to receive(:puts)
      allow($stdin).to receive(:gets).and_return("aaaa", "1111")
      expect(test_player.make_guess(arg)).to match_array([1, 1, 1, 1])
    end
  end

  describe "#set_code" do
    it "returns valid string converted to array of ints" do 
      allow($stdout).to receive(:puts)
      allow($stdin).to receive(:gets).and_return("6666")
      expect(test_player.set_code).to match_array([6, 6, 6, 6])
    end

    it "returns the first valid input provided" do
      allow($stdout).to receive(:puts)
      allow($stdin).to receive(:gets).and_return("not a code", "another not code", "9999", "1234")
      expect(test_player.set_code).to match_array([1, 2, 3, 4])
    end
  end
end