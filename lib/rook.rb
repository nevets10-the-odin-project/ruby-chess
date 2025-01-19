require_relative 'piece'

class Rook < Piece
  def initialize(player_index)
    icon = player_index.zero? ? '♖' : '♜'
    super('Rook', player_index, icon)
  end
end
