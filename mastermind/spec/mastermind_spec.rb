require_relative '../lib/mastermind.rb'

describe Mastermind do
  subject(:test_game) { described_class.new }

  describe "#play" do
    it "sets roles and code" do
      human_double = double()
      computer_double = double()
      allow(HumanPlayer).to receive(:new).and_return(human_double)
      allow(ComputerPlayer).to receive(:new).and_return(computer_double)
      allow($stdout).to receive(:puts) # so won't print message in test
      allow($stdin).to receive(:gets).and_return("y")
      allow(computer_double).to receive(:set_code).and_return([1, 1, 1, 1])
      allow(test_game).to receive(:take_turns)
      allow(test_game).to receive(:announce_winner)

      test_game.play
      expect(test_game.codebreaker).to be human_double
      expect(test_game.codemaker).to be computer_double
      expect(test_game.code).to eq [1, 1, 1, 1]
    end

    it "takes turns" do
      allow(test_game).to receive(:setup)
      allow(test_game).to receive(:announce_winner)

      expect(test_game).to receive(:take_turns)
      test_game.play
    end

    it "announces winner" do
      allow(test_game).to receive(:setup)
      allow(test_game).to receive(:take_turns)
      test_game.codemaker = double(name: "codemaker")
      test_game.codebreaker = double(name: "codebreaker")

      expect(test_game).to receive(:announce_winner) 
      test_game.play
    end
  end
end