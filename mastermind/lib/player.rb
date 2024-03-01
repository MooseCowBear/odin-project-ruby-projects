class Player
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end

  def make_guess(prev_feedback)
    raise "This method must be defined in the subclass."
  end

  def set_code
    raise "This method must be defined in the subclass."
  end
end