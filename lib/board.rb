class Board
  attr_accessor :spaces
  attr_reader :pieces

  def initialize(pieces)
    @pieces = pieces
    @spaces = build_board
  end
end
