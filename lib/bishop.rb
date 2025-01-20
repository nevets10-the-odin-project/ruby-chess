require_relative 'piece'

class Bishop < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♗' : '♝'
    super('Bishop', player_index, piece_index, icon)
  end

  def filter_moves(current_position)
    possible_moves = []
    (1..8).each do |step|
      possible_moves << [current_position[0] + step, current_position[1] + step]
      possible_moves << [current_position[0] + step, current_position[1] - step]
      possible_moves << [current_position[0] - step, current_position[1] + step]
      possible_moves << [current_position[0] - step, current_position[1] - step]
    end
    possible_moves.filter { |x, y| x.between?(0..7) && y.between?(0..7) }
  end
end
