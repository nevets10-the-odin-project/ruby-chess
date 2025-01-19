require_relative 'piece'

class King < Piece
  def initialize(player_index)
    icon = player_index.zero? ? '♔' : '♚'
    super('King', player_index, icon)
  end
end
