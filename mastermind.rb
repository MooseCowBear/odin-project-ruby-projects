module Feedback
  def give_feedback(code, guess) 
    feedback = Array.new
    check_color_code = Array.new 
    check_color_guess = Array.new

    code.each_with_index do |elem, index| #checking for exact matches
      if guess[index] == elem
        feedback.push("B")
      else
        check_color_code.push(elem)
        check_color_guess.push(guess[index]) #saving remains to check color matches
      end
    end

    while check_color_code.length > 0 #now check color matches
      elem = check_color_code.pop()
      if check_color_guess.include?(elem)
        feedback.push("W")
        check_color_guess.delete(elem)
      end
    end
    feedback = feedback.join
  end
end

class Mastermind
  include Feedback

  def initialize
    @code = nil
    @guesses_remaining = 12
    @winner = nil
    @codebreaker_human = false
    @computer_player = ComputerPlayer.new
    @human_player = HumanPlayer.new
  end

  def play_game 
    feedback = nil
    loop do 
      get_codebreaker
      get_code

      loop do
        puts "Guess ##{13 - guesses_remaining}"
        guess = get_player_guess(feedback)
        feedback = give_feedback(code, guess)
        pp feedback
        done = check_win(feedback)
        break if done 
        self.guesses_remaining -= 1
      end
      annouce_winner
      puts "Would you like to play again? y/n"
      again = gets.chomp
      break unless again.downcase[0] == "y"
      reset
    end
  end

  private
  attr_accessor :winner, :computer_player, :human_player, :codebreaker_human, :guesses_remaining, :code

  def get_codebreaker
    loop do
      puts "Would you like to be the codebreaker? y/n"
      preference = gets.chomp
      if preference.downcase[0] == "y" 
        self.codebreaker_human = true
        break
      elsif preference.downcase[0] == "n"
        break
      end
    end
  end

  def get_code 
    if codebreaker_human 
      self.code = computer_player.generate_code 
    else
      self.code = human_player_code
    end
  end

  def human_player_code
    code = nil
    loop do
      puts "Enter a code for the computer to guess: "
      code = gets.chomp
      code = process_input(code)
      break if validate_guess(code)
    end
    code
  end

  def get_player_guess(feedback)
    if codebreaker_human
      guess = get_human_player_guess
      guess
    else
      guess = get_computer_guess(feedback)
      guess
    end
  end

  def get_human_player_guess
    guess = nil
    loop do
      puts "Make a guess: " 
      guess = gets.chomp
      guess = process_input(guess)
      break if validate_guess(guess)
    end
    guess
  end

  def process_input(input)
    input = input.split("") #assumes they enter the guess like '1234'
    input = input.map{ |elem| elem.to_i }
    input
  end

  def get_computer_guess(feedback)
    computer_player.make_guess(guesses_remaining, feedback)
    computer_player.guess
  end

  def validate_guess(guess)
    if guess.length == 4 && guess.all? { |elem| (1..6).include?(elem) }
      return true
    end
    false
  end

  def check_win(feedback)
    if feedback == "BBBB"
      self.winner = codebreaker_human ? human_player : computer_player
      return true
    elsif guesses_remaining == 0
      self.winner = codebreaker_human ? computer_player : human_player
      return true
    end
    false
  end

  def annouce_winner 
    if winner == human_player
      puts "Congratulations, #{human_player.name}. You won!"
    else
      puts "Computer wins!"
    end
  end

  def reset 
    self.code = nil
    self.guesses_remaining = 12
    self.winner = nil
    self.codebreaker_human = false
    self.computer_player = ComputerPlayer.new
  end

end

class ComputerPlayer 
  include Feedback

  def initialize
    @viable = get_options
    @not_viable = Array.new
    @guess = [1, 1, 2, 2] 
  end

  attr_accessor :guess

  def generate_code #if computer is code maker
    code = Array.new
    4.times do 
      code.push(rand(1..6))
    end
    code
  end

  def make_guess(guesses_remaining, feedback)
    if guesses_remaining == 12
      puts "My guess is #{ guess.map{ |elem| elem.to_s }.join }"
      return guess
    end
    puts "Thinking..."
    calculate_next_guess(feedback)
    puts "My guess is #{ guess.map{ |elem| elem.to_s }.join }"
    guess
  end

  private

  attr_accessor :viable, :not_viable

  def get_options
    s = [
      [1, 2, 3, 4, 5, 6], 
      [1, 2, 3, 4, 5, 6], 
      [1, 2, 3, 4, 5, 6], 
      [1, 2, 3, 4, 5, 6]
    ]

    s[1..-1].reduce(s[0]){ |m,v| m = m.product(v).map(&:flatten) }
  end

  def remove_not_viable(feedback)
    viable.select{ |hypothetical_code| feedback != give_feedback(hypothetical_code, guess)} 
  end

  def get_max_include(hypothetical_code)
    max_consistent = 0
    outcomes = [
      "", "W", "WW", "WWW", "WWWW", "B", "BW", 
      "BWW", "BWWW", "BB", "BBW", "BBWW", "BBB", "BBBB"
    ]

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

  def calculate_next_guess(feedback) 
    not_viable.concat(remove_not_viable(feedback))
  
    self.viable = viable.reject{ |elem| not_viable.include?(elem) } 

    min_viable = 1500
    min_viable_guess = nil

    viable.each do |x|
      score = get_max_include(x)
      if score < min_viable
        min_viable = score
        min_viable_guess = x
      end #end if
    end #end each

    min_not_viable = 1500
    min_not_viable_guess = nil

    not_viable.each do |x|
      score = get_max_include(x)
      if score < min_not_viable
        min_not_viable = score
        min_not_viable_guess = x
      end
    end
    self.guess = min_viable <= min_not_viable ? min_viable_guess : min_not_viable_guess
    guess
  end #end def

end

class HumanPlayer 
  def initialize
    @name = get_name
  end

  attr_accessor :name

  private

  def get_name
    puts "What is your name?"
    self.name = gets.chomp
  end
end

game = Mastermind.new
game.play_game