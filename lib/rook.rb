require_relative 'piece'

class Rook < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♖' : '♜'
    super('Rook', player_index, piece_index, icon)
  end

  def filter_moves(current_position)
    possible_moves = []
    (0..7).each do |new_index|
      possible_moves << [current_position[0], new_index] unless current_position == [current_position[0], new_index]
      possible_moves << [new_index, current_position[1]] unless current_position == [new_index, current_position[1]]
    end
    possible_moves
  end
end
