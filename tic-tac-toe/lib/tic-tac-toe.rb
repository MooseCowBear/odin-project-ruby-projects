require_relative './board_game.rb'
require_relative './player.rb'

class TicTacToe
  include BoardGame

  attr_accessor :player1, :player2, :board, :curr_player, :winner, :remaining_squares

  def initialize
    @player1 = nil
    @player2 = nil
    @board = get_starting_board
    @winner = nil
    @curr_player = 1
    @remaining_squares = (1..9).to_a
  end

  def play
    self.player1 = get_player(1)
    self.player2 = get_player(2)
    display_turns
    print_board
    announce_result
  end

  def get_player(player_num)
    puts "Enter name for Player #{player_num}:"
    player_name = gets.chomp
    Player.new(player_name)
  end

  def take_turn
    puts "The current board is: "
    print_board
    move = get_move
    update_board(board, move, get_mark)
    game_winner = find_winner?(move)
    record_winner if game_winner
    self.curr_player = update_player_turn(curr_player, 2)
  end

  def display_turns
    take_turn until game_over?
  end

  def find_winner?(move) 
    mark = get_mark
    winning_row?(move, mark) || winning_column?(move, mark) || winning_diagonal?(move, mark)
  end

  def get_move
    player = curr_player < 2 ? player1 : player2
    
    loop do 
      puts "Enter move for #{player.name}: " 
      move = gets.chomp.to_i
      if remaining_squares.include?(move)
        self.remaining_squares.delete(move)
        move = convert_move(move)
        return move
      end
      puts "Remaining squares are: #{remaining_squares}"
    end
  end

  def draw?
    if winner.nil? && remaining_squares.empty?
      return true
    end
    false
  end

  def game_over?
    !winner.nil? || draw?
  end

  private

  def get_starting_board
    board = Array.new(3) { Array.new(3) }
    3.times do |i|
      3.times do |j|
        board[i][j] = 3 * i + j + 1 #fill board with 1 - 9 to indicate choices
      end
    end
    board
  end

  def update_curr_player 
    self.curr_player = update_player_turn(curr_player, 2)
  end

  def convert_move(num) #take number 1 - 9, and convert to indices - replaced with module
    j = (num - 1) % 3
    i = (num - (j + 1)) / 3
    [i, j]
  end

  def get_mark #player1 is "X"
    curr_player > 1 ? "O" : "X"
  end

  def winning_row?(move, mark)
    i = move[0]
    3.times do |j|
      unless board[i][j] == mark #if they don't match no winning row
        return false
      end
    end
    true
  end

  def winning_column?(move, mark)
    i = move[1]
    3.times do |j|
      unless board[j][i] == mark
        return false
      end
    end
    true
  end

  def winning_diagonal?(move, mark) 
    unless move[0] == move[1] || (move[0] + move[1] == 2)
      return false
    end
    left_right = true
    3.times do |i|
      unless board[i][i] == mark
        left_right = false
        break
      end
    end

    right_left = true
    3.times do |i|
      j = 2 - i
      unless board[i][j] == mark
        right_left = false
        break
      end
    end
    left_right || right_left
  end

  def record_winner
    self.winner = curr_player > 1 ? player2 : player1 
  end

  def announce_result
    if winner 
      puts "Congratulations, #{winner.name}!"
    else
      puts "It's a draw"
    end
  end

  def print_board
    board.each { |elem| pp elem }
  end
end