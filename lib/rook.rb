require_relative 'piece'

class Rook < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♖' : '♜'
    super('Rook', player_index, piece_index, icon)
  end
end
