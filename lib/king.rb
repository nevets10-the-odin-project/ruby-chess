require_relative 'piece'

class King < Piece
  MOVES = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]].freeze

  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♔' : '♚'
    super('King', player_index, piece_index, icon)
  end

  def filter_moves(current_position, board)
    potential_moves = board.map { |move| [move[0] + current_position[0], move[1] + current_position[1]] }
    potential_moves.filter { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end
end
