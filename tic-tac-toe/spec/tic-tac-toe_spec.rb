require_relative '../lib/tic-tac-toe.rb'
require_relative '../lib/player.rb'
require_relative '../lib/board_game.rb'

describe TicTacToe do
  describe '#initialize' do
    subject(:starting_game) { described_class.new }

    it 'contains an empty 3x3 board' do 
      empty_board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      game_board = starting_game.board
      expect(game_board).to eq(empty_board)
    end
  end

  subject(:game) { described_class.new }
  let(:player_one) { double(name: "evan") }
  let(:player_two) { double(name: "adam") }

  describe '#draw?' do
    context 'when no remaining squares to play and no winner' do
      it 'returns true' do
        game.remaining_squares = []
        expect(game.draw?).to be true
      end
    end

    context 'when no remaining squares to play but winner' do
      let(:game_winner) { double(name: "evan") }

      it 'returns false' do
        game.winner = game_winner
        game.remaining_squares = []
        expect(game.draw?).to be false
      end
    end
  
    context 'when remaining squares' do

      it 'returns false' do
        game.remaining_squares = [2, 4, 6, 8]
        expect(game.draw?).to be false
      end
    end
  end

  describe '#find_winner?' do
    let(:move_to_check) { [0, 0] }

    before do
      allow(game).to receive(:get_mark).and_return("X")
    end

    context 'when there is no winner' do
      it 'returns false' do
        expect(game.find_winner?(move_to_check)).to be false
      end
    end
    
    context 'when a row has been filled' do
      it 'returns true' do
        game.board = [["X", "X", "X"], [nil, nil, nil], [nil, nil, nil]]
        expect(game.find_winner?(move_to_check)).to be true
      end
    end

    context 'when a column has been filled' do
      it 'returns true' do
        game.board = [["X", nil, nil], ["X", nil, nil], ["X", nil, nil]]
        expect(game.find_winner?(move_to_check)).to be true
      end
    end

    context 'when a diagonal has been filled' do
      it 'returns true' do
        game.board = [["X", nil, nil], [nil, "X", nil], ["X", nil, "X"]]
        expect(game.find_winner?(move_to_check)).to be true
      end
    end
  end

  describe '#get_move' do
    context 'when given a valid number' do
      before do
        allow(game).to receive(:gets).and_return("7")
      end

      it 'calls gets once' do
        game.player1 = player_one
        expect(game).to receive(:gets).once
        game.get_move
      end
    end

    context 'when given an invalid number, followed by a valid number' do
      before do
        allow(game).to receive(:gets).and_return("100", "5")
      end

      it 'calls gets twice' do
        game.player1 = player_one
        expect(game).to receive(:gets).twice
        game.get_move
      end
    end

    context 'when given a non-number, followed by a valid number' do
      before do
        allow(game).to receive(:gets).and_return("b", "5")
      end

      it 'calls gets twice' do
        game.player1 = player_one
        expect(game).to receive(:gets).twice
        game.get_move
      end
    end
  end

  describe '#get_player' do 
    before do
      allow(game).to receive(:gets).and_return("martin")
    end

    it 'returns a new player with the name provided' do
      new_player = game.get_player(3)
      expect(new_player).to have_attributes(:name => "martin")
    end
  end

  describe '#display_turns' do
    context 'when game_over? is false once' do
      before do 
        allow(game).to receive(:game_over?).and_return(false, true)
      end

      it 'calls take_turn once' do
        expect(game).to receive(:take_turn).once
        game.display_turns
      end
    end

    context 'when game_over? is false 3 times' do
      before do
        allow(game).to receive(:game_over?).and_return(false, false, false, true)
      end

      it 'calls take_turn 3 times' do
        expect(game).to receive(:take_turn).exactly(3).times
        game.display_turns
      end
    end
  end

  describe '#take_turn' do 
    before do
      allow(game).to receive(:get_move).and_return([0, 0])
      allow(game).to receive(:update_player_turn).with(1, 2).and_return(2)
      allow(game).to receive(:find_winner?).with([0, 0]).and_return(true)
    end

    it 'calls get_move' do
      game.player1 = player_one
      expect(game).to receive(:get_move).once
      game.take_turn
    end

    it 'calls update_board' do
      game.player1 = player_one
      expect(game). to receive(:update_board).once
      game.take_turn
    end

    it 'calls update_player_turn player' do
      game.player1 = player_one
      expect(game). to receive(:update_player_turn).once
      game.take_turn
    end

    it 'calls find_winner' do
      game.player1 = player_one
      expect(game). to receive(:find_winner?).with([0, 0]).once
      game.take_turn
    end
    
    context 'when the game is won' do
      it 'calls record_winner' do
        game.player1 = player_one
        expect(game).to receive(:record_winner).once
        game.take_turn
      end
    end
  end

  describe '#play' do 
    before do
      allow(game).to receive(:get_player).with(1).and_return(player_one)
      allow(game).to receive(:get_player).with(2).and_return(player_two)
      allow(game).to receive(:get_move).and_return([0, 0])
      allow(game).to receive(:update_player_turn).with(1, 2).and_return(2)
      allow(game).to receive(:find_winner?).with([0, 0]).and_return(true)
    end

    it 'calls get_player twice' do
      expect(game).to receive(:get_player).twice
      game.play
    end

    it 'calls display_turns' do
      expect(game).to receive(:display_turns).once
      game.play
    end

    it 'calls announce_result' do
      expect(game).to receive(:announce_result).once
      game.play
    end
  end
end