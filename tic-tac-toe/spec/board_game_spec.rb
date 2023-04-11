require_relative '../lib/board_game.rb'

describe BoardGame do
  let(:dummy_class) { Class.new { extend BoardGame } }

  describe '#update_board' do
    let(:board) { [["_", "_"], ["_", "_"]] }
    
    it 'updates 2d board to include mark at position' do
      update = dummy_class.update_board(board, [0, 0], "X")
      expect(update).to eq([["X", "_"], ["_", "_"]])
    end
  end

  describe '#update_player_turn' do
    context 'for a two player game' do
      let(:players) { 2 }

      it 'updates from 1 to 2' do
        next_player = dummy_class.update_player_turn(1, players)
        expect(next_player).to eq(2)
      end

      it 'updates from 2 to 1' do
        next_player = dummy_class.update_player_turn(2, players)
        expect(next_player).to eq(1)
      end
    end

    context 'for a three player game' do
      let(:players) { 3 }
      it 'updates from 1 to 2' do
        next_player = dummy_class.update_player_turn(1, players)
        expect(next_player).to eq(2)
      end

      it 'updates from 3 to 1' do
        next_player = dummy_class.update_player_turn(3, players)
        expect(next_player).to eq(1)
      end
    end
  end
end