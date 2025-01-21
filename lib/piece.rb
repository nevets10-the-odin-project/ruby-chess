class Piece
  attr_reader :type, :player_index, :piece_index, :icon, :abbreviation, :properties

  def initialize(type, player_index, piece_index, icon, abbreviation, properties = [])
    @type = type
    @player_index = player_index
    @piece_index = piece_index
    @icon = icon
    @abbreviation = abbreviation
    @properties = properties
  end
end
