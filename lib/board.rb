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

  def convert_input(input)
    [BOARD_COLUMNS.index(input[0]), input[1].to_i - 1]
  end

  def validate_move(target, destination, current_player)
    target_xy = convert_input(target)
    destination_xy = convert_input(destination)
    target_piece = spaces[target_xy[0]][target_xy[1]]
    destination_piece = spaces[destination_xy[0]][destination_xy[1]]
    if @move_history.last
      last_move = "#{convert_input(@move_history.last[1..2]).join('')}#{convert_input(@move_history.last[3..4]).join('')}"
    end
    last_piece_abbvr = @move_history.last[0, 1] if @move_history.last
    return unless target_piece&.player_index == current_player
    return if destination_piece&.player_index == current_player
    return if target_piece.properties.none?('leap') && blocking_piece?(target_xy, destination_xy)
    return unless target_piece.valid_move?(target_xy, destination_xy, destination_piece, last_move, last_piece_abbvr)

    possible_moves = target_piece.filter_moves(target_xy)
    return unless possible_moves.any?(destination_xy)

    if last_move && target_piece.type == 'Pawn' && target_piece.en_passant?(
      target_xy, destination_xy, last_move, last_piece_abbvr
    )
      update_space([last_move[2].to_i, last_move[3].to_i],
                   nil)
    end

    target_piece.incr_move_count
    destination_xy
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
    target_xy = convert_input(user_input[0..1])
    destination_xy = convert_input(user_input[2..3])
    options = user_input[4].split('') if user_input[4]
    piece = @spaces[target_xy[0]][target_xy[1]]

    @spaces[destination_xy[0]][destination_xy[1]] = piece
    @spaces[target_xy[0]][target_xy[1]] = nil
  end

  def update_space(space_xy, new_value)
    @spaces[space_xy[0]][space_xy[1]] = new_value
  end

  def update_move_history(move)
    @move_history << move
  end

  def piece_abbreviation(user_input)
    piece = spaces[convert_input(user_input)[0]][convert_input(user_input)[1]]
    piece.abbreviation
  end
end
