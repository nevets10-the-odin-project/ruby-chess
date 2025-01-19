class Piece
  attr_reader :type, :player_index, :icon

  def initialize(type, player_index, icon)
    @type = type
    @player_index = player_index
    @icon = icon
  end
end
