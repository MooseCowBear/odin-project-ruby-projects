require_relative "./player.rb"
require_relative "./feedback.rb"

class ComputerPlayer < Player
  include Feedback 

  attr_accessor :possible_codes, :impossible_codes, :guess

  def initialize
    super("Hal")
    @possible_codes = generate_codes
    @impossible_codes = []
    @guess = [1, 1, 2, 2] # starting guess
  end

  def make_guess(prev_feedback)
    update_codes(prev_feedback) if prev_feedback

    if impossible_codes.length > 0
      best_pos = best_guess_from(possible_codes)
      best_impos = best_guess_from(impossible_codes)

      if best_impos.score < best_pos.score
        self.guess = best_impos.guess
      else 
        self.guess = best_pos.guess
      end
    end
    guess 
  end

  def set_code 
    possible_codes.sample
  end

  private

  def generate_codes
    # all 1296 possible codes
    s = Array.new(4, [1, 2, 3, 4, 5, 6])
    s[1..-1].reduce(s[0]){ |m,v| m = m.product(v).map(&:flatten) }
  end

  def update_codes(prev_feedback)
    keep, discard = possible_codes.partition { |code| consistent?(prev_feedback, code) }

    self.possible_codes = keep
    self.impossible_codes = impossible_codes + discard
  end

  def consistent?(prev_feedback, code)
    feedback(code, guess) == prev_feedback # would this code give me the feedback I got?
  end

  def score(hypothetical_guess)
    # calculate the worst outcome for this guess
    outcome_tallies = Hash.new(0)

    possible_codes.each do |code|
      outcome_tallies[feedback(code, hypothetical_guess)] += 1
    end
    outcome_tallies.max_by{ |key, val| val }[1] # worst case is the greatest number of possible remaining codes
  end

  Guess = Struct.new(:guess, :score)

  def best_guess_from(codes)
    min_score = 1296
    best_guess = nil

    codes.each do |code|
      score = score(code)
      if score < min_score
        min_score = score
        best_guess = code
      end
    end
    Guess.new(best_guess, min_score)
  end
end
