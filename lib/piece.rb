class Piece
  attr_reader :type, :player_index, :piece_index, :icon

  def initialize(type, player_index, piece_index, icon)
    @type = type
    @player_index = player_index
    @piece_index = piece_index
    @icon = icon
  end
end
