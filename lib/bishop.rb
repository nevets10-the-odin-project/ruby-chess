require_relative 'piece'

class Bishop < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♗' : '♝'
    super('Bishop', player_index, piece_index, icon)
  end
end
