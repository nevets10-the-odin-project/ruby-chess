require_relative 'piece'

class Bishop < Piece
  def initialize(player_index)
    icon = player_index.zero? ? '♗' : '♝'
    super('Bishop', player_index, icon)
  end
end
