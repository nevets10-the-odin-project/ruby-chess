class Board
  attr_accessor :spaces
  attr_reader :pieces

  def initialize(pieces)
    @pieces = pieces
    @spaces = build_spaces(pieces)
  end

  def build_spaces(pieces)
    columns = []
    (0..7).each do |column_index|
      case column_index
      when 0
        current_column = build_column(pieces, column_index, 'Rook', 0)
      when 1
        current_column = build_column(pieces, column_index, 'Knight', 0)
      when 2
        current_column = build_column(pieces, column_index, 'Bishop', 0)
      when 3
        current_column = build_column(pieces, column_index, 'Queen', 0)
      when 4
        current_column = build_column(pieces, column_index, 'King', 0)
      when 5
        current_column = build_column(pieces, column_index, 'Bishop', 1)
      when 6
        current_column = build_column(pieces, column_index, 'Knight', 1)
      when 7
        current_column = build_column(pieces, column_index, 'Rook', 1)
      end
      columns << current_column
    end
    columns
  end

  def build_column(pieces, column_index, piece_type, piece_index)
    specific_piece = pieces.filter { |piece| piece.type == piece_type && piece.piece_index == piece_index }
    pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
    current_column = []
    current_column << specific_piece[0]
    current_column << pawns[0]
    4.times { current_column << nil }
    current_column << pawns[1]
    current_column << specific_piece[1]
    current_column
  end

  def print_board
    puts '    a   b   c   d   e   f   g   h'
    (0..7).reverse_each do |row_index|
      print row_index
      @spaces.each do |column|
        print ' | '
        if column[row_index]
          print column[row_index].icon
        else
          print ' '
        end
      end
      print ' |'
      puts " #{row_index}"
      puts '  ---------------------------------' unless row_index.zero?
    end
    puts '    a   b   c   d   e   f   g   h'
  end
end
