class Piece
  attr_reader :type, :player_index, :piece_index, :icon, :abbreviation, :properties, :move_count

  def initialize(type, player_index, piece_index, icon, abbreviation, properties = [])
    @type = type
    @player_index = player_index
    @piece_index = piece_index
    @icon = icon
    @abbreviation = abbreviation
    @properties = properties
    @move_count = 0
  end

  def incr_move_count
    @move_count += 1
  end
end
