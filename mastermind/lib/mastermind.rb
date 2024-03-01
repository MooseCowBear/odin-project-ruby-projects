require_relative "./feedback.rb"
require_relative "./human_player.rb"
require_relative "./computer_player.rb"

class Mastermind
  include Feedback

  attr_accessor :code, :guesses_remaining, :code_broken, :codebreaker, :codemaker

  def initialize
    @code = nil
    @guesses_remaining = 12
    @code_broken = false
    @codebreaker = nil
    @codemaker = nil
  end

  def play
    setup
    take_turns
    announce_winner
  end

  private

  def setup
    set_roles(HumanPlayer.new, ComputerPlayer.new)
    self.code = codemaker.set_code
  end

  def set_roles(human, computer)
    loop do
      puts "Would you like to be the codebreaker? y/n"
      preference = $stdin.gets.chomp
      if preference.downcase[0] == "y" 
        self.codebreaker = human
        self.codemaker = computer
        break
      elsif preference.downcase[0] == "n"
        self.codebreaker = computer
        self.codemaker = human
        break
      end
    end
  end

  def take_turns
    feedback = nil
    while guesses_remaining > 0 && !code_broken
      announce_round
      guess = get_guess(feedback)
      feedback = feedback(code, guess)
      announce_feedback(guess, feedback)
      update_code_broken(feedback)
      update_round
    end
  end

  def announce_round
    puts "Guess ##{13 - guesses_remaining}"
  end

  def announce_feedback(guess, feedback)
    puts "#{codebreaker.name} guessed: #{guess.join}. The feedback for #{codebreaker.name}'s guess is '#{feedback}'"
  end

  def get_guess(feedback)
    codebreaker.make_guess(feedback)
  end

  def update_round
    self.guesses_remaining -= 1
  end

  def update_code_broken(feedback)
    self.code_broken = true if feedback == "BBBB"
  end

  def announce_winner
    if code_broken
      puts "#{codebreaker.name} broke the code!"
    else
      puts "#{codemaker.name}'s code was unbreakable!"
    end
  end
end
