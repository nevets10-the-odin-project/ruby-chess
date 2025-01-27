class Piece
  attr_reader :type, :player_index, :piece_index, :icon, :abbreviation, :properties, :move_count

  def initialize(type, player_index, piece_index, icon, abbreviation, move_count = 0, properties = [])
    @type = type
    @player_index = player_index
    @piece_index = piece_index
    @icon = icon
    @abbreviation = abbreviation
    @move_count = move_count
    @properties = properties
  end

  def incr_move_count
    @move_count += 1
  end

  def valid_move?(move, last_move, last_piece_abbvr)
    true
  end
end
