class Board
  attr_accessor :spaces
  attr_reader :pieces

  def initialize(pieces)
    @pieces = pieces
    @spaces = build_spaces
  end

  def build_spaces
    column = []
    8.times do
      column << []
    end
    column
  end
end
