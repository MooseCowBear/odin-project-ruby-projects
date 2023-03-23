module Feedback
  def give_feedback(code, guess) #black (i.e. right color, right position) gets priority
    feedback = Array.new
    check_color_code = Array.new #hang on to what's left over
    check_color_guess = Array.new

    code.each_with_index do |elem, index| #checking for exact matches
      if guess[index] == elem
        feedback.push("B")
      else
        check_color_code.push(elem)
        check_color_guess.push(guess[index]) #saving remains to check color matches
      end
    end
    puts "check color code: #{check_color_code}"
    puts "check color guess: #{check_color_guess}"
    while check_color_code.length > 0 #now check color matches
      elem = check_color_code.pop()
      if check_color_guess.include?(elem)
        feedback.push("W")
        check_color_guess.delete(elem)
      end
    end
    pp feedback
    feedback
  end
end


class Mastermind
  extend Feedback
  def initialize
    @code = get_code #will change, to add later - after finding out what kind of game we are playing
    @guesses_remaining = 12
    @winner = nil
  end

  def play_game #NEEDS TO CHANGE
    while guesses_remaining > 0
      guess = get_player_guess #human as code breaker
      puts "guess: #{guess}"
      feedback = give_feedback(code, guess) #change to module method which passes code, guess

      if guess == code
        puts "You win!"
        return 
      end
    end
  end

  private
  attr_accessor :guesses_remaining
  attr_reader :code

  def get_code #generate random computer code
    code = Array.new
    6.times do 
      code.push(rand(1..6))
    end
    puts "code is: #{code}"
    code
  end

  def get_player_guess
    loop do
      puts "Make a guess: " 
      guess = gets.chomp
      guess = guess.split("") #assumes they enter the guess like 123456
      guess.map{ |elem| elem.to_i}
      if validate_guess(guess) { break }
    end
    guess
  end

  def validate_guess(guess)
    if guess.lenth == 6 && guess.all? { |elem| (1..6).include?(elem) }
      return true
    end
    false
  end

  def annouce_winner 

  end
end

## make a computer class that stores the algo for computer, its knowledge state etc
class ComputerPlayer 
  extend Feedback
  def initialize
    @viable = get_options
    @not_viable = []
    @guess = [1, 1, 2, 2] #starting guess

  end

  attr_accessor :viable, :not_viable, :guess

  def get_options
    s = [[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6]]
    s[1..-1].reduce(s[0]){ |m,v| m = m.product(v).map(&:flatten) }
  end

  def remove_not_viable(feedback)
    x = viable.select{ |hypothetical_code| feedback != give_feedback(hypothetical_code, guess)} #computer needs access to get feedback method...
    pp x
    x
  end

  def get_max_include(hypothetical_code)
    max_consistent = 0
    outcomes = [[0, 0], [0,1], [0,2], [0,3], [0,4], [1,0], [1,1], [1,2], [1,3], [2,0], [2,1], [2,2], [3,0], [4,0]]
    outcomes.each do |outcome|
      count = 0
      viable.each do |option|
        x = give_feedback(hypothetical_code, option)
        if x == outcome
          count += 1
        end
      end
      max_consistent = [max_consistent, count].max
    end #end outcomes.each
    max_consistent
  end #end def

  def calculate_next_guess(feedback) #returns next guess
    not_viable = not_viable + remove_not_viable(feedback)
    viable = viable.select{ |elem| not_viable.include?(elem) }
    puts "viable after removing not viable elements: "
    pp viable
    puts "not_viable after update: "
    pp not_viable

    min_viable = Float::Infinity
    min_viable_guess = nil

    min_not_viable = Float::Infinity
    min_not_viable_guess = nil

    viable.each do |x|
      score = get_max_include(x)
      if score < min_viable
        min_viable = score
        min_viable_guess = x
      end #end if
    end #end each

    not_viable.each do |x|
      score = get_max_include(x)
      if score < min_not_viable
        min_not_viable = score
        min_not_viable_guess = x
      end
    end
    guess = min_viable <= min_not_viable ? min_viable_guess : min_not_viable_guess
    guess
  end #end def
end

game = Mastermind.new
game.play_game