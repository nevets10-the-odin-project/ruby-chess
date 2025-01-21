require_relative 'piece'

class Knight < Piece
  MOVES = [[2, 1], [1, 2], [-2, 1], [1, -2], [2, -1], [-1, 2], [-2, -1], [-1, -2]].freeze

  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♘' : '♞'
    super('Knight', player_index, piece_index, icon, ['leap'])
  end

  def filter_moves(current_position)
    potential_moves = MOVES.map { |move| [move[0] + current_position[0], move[1] + current_position[1]] }
    potential_moves.filter { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end

  def valid_move?(target_xy, destination_xy, destination_piece, last_move)
    true
  end
end
