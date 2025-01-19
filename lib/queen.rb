require_relative 'piece'

class Queen < Piece
  def initialize(player_index)
    icon = player_index.zero? ? '♕' : '♛'
    super('Queen', player_index, icon)
  end
end
