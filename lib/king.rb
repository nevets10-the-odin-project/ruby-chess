require_relative 'piece'

class King < Piece
  MOVES = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1], [2, 0], [-2, 0]].freeze

  def initialize(player_index, piece_index, move_count = 0)
    icon = player_index.zero? ? '♔' : '♚'
    super('King', player_index, piece_index, icon, 'k', move_count)
  end

  def filter_moves(current_position)
    potential_moves = MOVES.map { |move| [move[0] + current_position[0], move[1] + current_position[1]] }
    potential_moves.filter { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end

  def valid_move?(move, last_move, last_piece_abbvr)
    return true if move[:castling] && move[:destination_xy].join('').match?(/(2|6)(0|7)/)

    true if !move[:castling] && !move[:destination_xy].join('').match?(/(2|6)(0|7)/)
  end
end
