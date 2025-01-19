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
        rooks = pieces.filter { |piece| piece.type == 'Rook' && piece.piece_index == 0 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(rooks, pawns)
      when 1
        knights = pieces.filter { |piece| piece.type == 'Knight' && piece.piece_index == 0 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(knights, pawns)
      when 2
        bishops = pieces.filter { |piece| piece.type == 'Bishop' && piece.piece_index == 0 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(bishops, pawns)
      when 3
        queens = pieces.filter { |piece| piece.type == 'Queen' && piece.piece_index == 0 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(queens, pawns)
      when 4
        kings = pieces.filter { |piece| piece.type == 'King' && piece.piece_index == 0 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(kings, pawns)
      when 5
        bishops = pieces.filter { |piece| piece.type == 'Bishop' && piece.piece_index == 1 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(bishops, pawns)
      when 6
        knights = pieces.filter { |piece| piece.type == 'Knight' && piece.piece_index == 1 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(knights, pawns)
      when 7
        rooks = pieces.filter { |piece| piece.type == 'Rook' && piece.piece_index == 1 }
        pawns = pieces.filter { |piece| piece.type == 'Pawn' && piece.piece_index == column_index }
        current_column = build_column(rooks, pawns)
      end
      columns << current_column
    end
    columns
  end

  def build_column(specific_piece, pawns)
    current_column = []
    current_column << specific_piece[0]
    current_column << pawns[0]
    4.times { current_column << nil }
    current_column << pawns[1]
    current_column << specific_piece[1]
    current_column
  end

  def print_board
    (0..7).each do |row_index|
      @spaces.each_with_index do |column, column_index|
        print '|'
        if column[row_index]
          print column[row_index].icon
        else
          print ' '
        end
      end
      print '|'
      puts
      puts '-----------------'
    end
  end
end
