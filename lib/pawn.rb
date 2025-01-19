require_relative 'piece'

class Pawn < Piece
  def initialize(player_index)
    icon = player_index.zero? ? '♙' : '♟'
    super('Pawn', player_index, icon)
  end
end
