class Player
  attr_reader :name #so game can access names

  def initialize(name)
    @name = name
  end
end

class Game
  def initialize 
    @player1 = get_player(1);
    @player2 = get_player(2);
    @board = get_starting_board
    @winner = nil
    @curr_player = 1
    @remaining_squares = (1..9).to_a
  end

  def play_game 
    until winner || remaining_squares.length == 0
      puts "The current board is: "
      print_board
      move = get_move
      update_board(move)
      done = check_winner(move) 
      if done 
        self.winner = curr_player > 1 ? player2 : player1 
      end
      update_curr_player
    end
    announce_result
  end

  private

  attr_reader :player1, :player2
  attr_accessor :board, :curr_player, :winner, :remaining_squares

  def get_player(player_num)
    puts "Enter name for Player #{player_num}:"
    player_name = gets.chomp
    Player.new(player_name)
  end

  def get_starting_board
    board = Array.new(3) { Array.new(3) }
    3.times do |i|
      3.times do |j|
        board[i][j] = 3 * i + j + 1 #should result in 1 - 9
      end
    end
    board
  end

  def update_curr_player 
    self.curr_player = (curr_player % 2) + 1
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
    end
  end

  def convert_move(num) #take number 1 - 9, and convert to indices
    j = (num - 1) % 3
    i = (num - (j + 1)) / 3
    [i, j]
  end

  def get_mark #player1 is "X"
     mark = curr_player > 1 ? "O" : "X"
     mark
  end

  def update_board(move) 
    mark = get_mark
    row = move[0] 
    col = move[1]
    board[row][col] = mark
  end

  def check_winner(move) 
    mark = get_mark
    winning_row?(move, mark) || winning_column?(move, mark) || winning_diagonal?(move, mark)
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

game = Game.new
game.play_game