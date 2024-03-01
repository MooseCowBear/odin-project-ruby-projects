require_relative "./player.rb"

class HumanPlayer < Player
  def initialize(name)
    super(name || get_name)
  end

  def make_guess(prev_feedback)
    get_code("Make a guess:")
  end

  def set_code
    get_code("Choose a code:")
  end

  private 

  def get_name
    puts "What is your name?"
    self.name = gets.chomp
  end

  def valid?(input)
    /^[1-6]{4}$/.match?(input)
  end

  def get_code(message)
    puts message 
    input = $stdin.gets.chomp
    return input.split("").map(&:to_i) if valid?(input)
    get_code(message)
  end
end