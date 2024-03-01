require_relative '../lib/player.rb'

describe Player do
  subject(:test_player) { described_class.new("Sally") }

  describe "#make_guess" do
    it "raises error indicating the method needs to be defined in subclass" do
      arg = double()
      expect { test_player.make_guess(arg) }.to raise_error("This method must be defined in the subclass.")
    end
  end

  describe "#set_code" do
    it "raises error indicating the method needs to be defined in subclass" do
      expect { test_player.set_code }.to raise_error("This method must be defined in the subclass.")
    end
  end
end