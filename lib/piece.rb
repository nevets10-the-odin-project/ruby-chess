class Piece
  attr_reader :type, :player_index, :piece_index, :icon, :properties

  def initialize(type, player_index, piece_index, icon, properties = [])
    @type = type
    @player_index = player_index
    @piece_index = piece_index
    @icon = icon
    @properties = properties
  end
end
