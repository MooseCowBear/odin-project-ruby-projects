module BoardGame
  def update_board(board, position, mark)
    row = position[0] 
    col = position[1]
    board[row][col] = mark
    board
  end

  def update_player_turn(curr_player_num, num_players)
    curr_player_num % num_players + 1
  end
end