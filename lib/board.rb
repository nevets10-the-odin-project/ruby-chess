class Board
  attr_accessor :spaces
  attr_reader :pieces, :move_history

  BOARD_COLUMNS = %w[a b c d e f g h].freeze

  def initialize(pieces)
    @pieces = pieces
    @spaces = build_spaces(pieces)
    @move_history = []
  end

  def build_spaces(pieces)
    columns = []
    columns << build_column(pieces, 0, 'Rook', 0)
    columns << build_column(pieces, 1, 'Knight', 0)
    columns << build_column(pieces, 2, 'Bishop', 0)
    columns << build_column(pieces, 3, 'Queen', 0)
    columns << build_column(pieces, 4, 'King', 0)
    columns << build_column(pieces, 5, 'Bishop', 1)
    columns << build_column(pieces, 6, 'Knight', 1)
    columns << build_column(pieces, 7, 'Rook', 1)
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
      print row_index + 1
      @spaces.each do |column|
        print ' | '
        if column[row_index]
          print column[row_index].icon
        else
          print ' '
        end
      end
      print ' |'
      puts " #{row_index + 1}"
      puts '  ---------------------------------' unless row_index.zero?
    end
    puts '    a   b   c   d   e   f   g   h'
  end

  def validate_move(target, destination, current_player)
    target_xy = [BOARD_COLUMNS.index(target[0]), target[1].to_i - 1]
    destination_xy = [BOARD_COLUMNS.index(destination[0]), destination[1].to_i - 1]
    target_piece = spaces[target_xy[0]][target_xy[1]]
    destination_piece = spaces[destination_xy[0]][destination_xy[1]]
    last_move = [BOARD_COLUMNS.index(@move_history.last[0]), @move_history.last[1].to_i - 1]
    return unless target_piece&.player_index == current_player
    return if destination_piece&.player_index == current_player
    return if target_piece.properties.none?('leap') && blocking_piece?(target_xy, destination_xy)
    return unless target_piece.valid_move?(target_xy, destination_xy, destination_piece, last_move)

    possible_moves = target_piece.filter_moves(target_xy)
    destination_xy if possible_moves.any?(destination_xy)
  end

  def blocking_piece?(target, destination, current_space = Array.new(target))
    return false if current_space.join('') == destination.join('')
    return true if spaces[current_space[0]][current_space[1]] && target.join('') != current_space.join('')

    new_x = if destination[0] > current_space[0]
              current_space[0] += 1
            elsif destination[0] < current_space[0]
              current_space[0] -= 1
            else
              current_space[0]
            end

    new_y = if destination[1] > current_space[1]
              current_space[1] += 1
            elsif destination[1] < current_space[1]
              current_space[1] -= 1
            else
              current_space[1]
            end

    blocking_piece?(target, destination, [new_x, new_y])
  end

  def update_board(user_input)
    target_xy = [BOARD_COLUMNS.index(user_input[0]), user_input[1].to_i - 1]
    destination_xy = [BOARD_COLUMNS.index(user_input[2]), user_input[3].to_i - 1]
    options = user_input[4].split('') if user_input[4]
    piece = @spaces[target_xy[0]][target_xy[1]]

    @spaces[destination_xy[0]][destination_xy[1]] = piece
    @spaces[target_xy[0]][target_xy[1]] = nil
  end

  def update_move_history(move)
    @move_history << move
  end

  def piece_abbreviation(user_input)
    piece = [BOARD_COLUMNS.index(user_input[0]), user_input[1].to_i - 1]
    piece.abbreviation
  end
end
