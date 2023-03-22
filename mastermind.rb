class Mastermind
  def initialize
    @code = get_code
    @guesses_remaining = 12
  end

  def play_game
    while guesses_remaining > 0
      guess = get_guess
      puts "guess: #{guess}"
      feedback = give_feedback(guess)

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

  def get_guess
    puts "Make a guess: " #again needs validation
    guess = gets.chomp
    guess = guess.split("") #assumes they enter the guess like 123456
    guess.map{ |elem| elem.to_i}
  end

  def give_feedback(guess) #black (i.e. right color, right position) gets priority
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

game = Mastermind.new
game.play_game