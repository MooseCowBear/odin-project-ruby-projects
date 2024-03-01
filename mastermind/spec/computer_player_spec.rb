require_relative '../lib/computer_player.rb'

describe ComputerPlayer do
  subject(:test_player) { described_class.new }

  describe("#initialize") do
    it "generates all 1296 codes and holds them in possible codes" do
      expect(test_player.possible_codes.length).to eq 1296
    end
  end

  describe("#set_code") do
    it "returns a code from possible codes" do
      res = test_player.set_code
      expect(test_player.possible_codes.include?(res)).to be true
    end
  end

  describe("#make_guess") do
    it "returns initial guess if impossible codes is empty" do
      expect(test_player.make_guess(nil)).to eq [1, 1, 2, 2]
    end

    it "returns best possible code if it has a lower score than best impossible code and updates player's guess" do
      allow(test_player.impossible_codes).to receive(:length).and_return(200)
      allow(test_player).to receive(:update_codes)

      best_pos = double(score: 10, guess: [1, 1, 1, 1])
      best_impos = double(score: 20, guess: [2, 2, 2, 2])

      allow(test_player).to receive(:best_guess_from).and_return(best_pos, best_impos)
      res = test_player.make_guess("")
      expect(res).to eq best_pos.guess
      expect(test_player.guess).to eq best_pos.guess 
    end

    it "returns best possible code if it has score equal to best impossible code" do
      allow(test_player.impossible_codes).to receive(:length).and_return(200)
      allow(test_player).to receive(:update_codes)

      best_pos = double(score: 10, guess: [1, 1, 1, 1])
      best_impos = double(score: 10, guess: [2, 2, 2, 2])

      allow(test_player).to receive(:best_guess_from).and_return(best_pos, best_impos)
      res = test_player.make_guess("")
      expect(res).to eq best_pos.guess
      expect(test_player.guess).to eq best_pos.guess 
    end

    it "returns best impossible code if it has a score lower than best possible code" do
      allow(test_player.impossible_codes).to receive(:length).and_return(200)
      allow(test_player).to receive(:update_codes)

      best_pos = double(score: 20, guess: [1, 1, 1, 1])
      best_impos = double(score: 10, guess: [2, 2, 2, 2])

      allow(test_player).to receive(:best_guess_from).and_return(best_pos, best_impos)
      res = test_player.make_guess("")
      expect(res).to eq best_impos.guess
      expect(test_player.guess).to eq best_impos.guess 
    end

    # testing that we are getting the right results from make guess
    context "when given specific scenarios" do
      it "updates possible and impossible codes as expected and chooses the correct code" do
        test_player.guess = [1, 1, 2, 2]
        test_player.possible_codes = [[1, 1, 1, 1], [1, 1, 3, 3], [1, 1, 3, 4], [2, 2, 1, 1], [3, 3, 3, 3]]
        test_player.impossible_codes = []
        res = test_player.make_guess("BB")
        expect(test_player.possible_codes).to match_array([[1, 1, 1, 1], [1, 1, 3, 3], [1, 1, 3, 4]])
        expect(test_player.impossible_codes).to match_array([[2, 2, 1, 1], [3, 3, 3, 3]])
        expect(res).to eq([1, 1, 3, 3]).or(eq([1, 1, 3, 4]))
      end
    end
  end
end