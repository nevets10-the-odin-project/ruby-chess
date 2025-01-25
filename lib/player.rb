class Player
  attr_reader :color, :can_castle

  def initialize(color)
    @color = color
    @can_castle = true
  end

  def update_castle
    @can_castle = false
  end
end
