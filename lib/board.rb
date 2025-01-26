class Board
  attr_accessor :spaces
  attr_reader :pieces, :move, :move_history

  BOARD_COLUMNS = %w[a b c d e f g h].freeze

  def initialize(pieces)
    @pieces = pieces
    @spaces = build_spaces(pieces)
    @move = nil
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

  def generate_move(target, destination, castling, current_player)
    {
      target_xy: convert_input(target),
      destination_xy: convert_input(destination),
      target_piece: spaces[convert_input(target)[0]][convert_input(target)[1]],
      destination_piece: spaces[convert_input(destination)[0]][convert_input(destination)[1]],
      current_player: current_player,
      castling: castling,
      en_passant: false
    }
  end

  def validate_move(move)
    if @move_history.last
      last_target_xy = convert_input(@move_history.last[1..2]).join('')
      last_destination_xy = convert_input(@move_history.last[3..4]).join('')
      last_move = "#{last_target_xy}#{last_destination_xy}"
    end

    last_piece_abbvr = @move_history.last[0, 1] if @move_history.last

    return unless move[:target_piece]&.player_index == move[:current_player]
    return unless move[:target_piece].valid_move?(move, last_move, last_piece_abbvr)
    return if move[:destination_piece]&.player_index == move[:current_player]
    return if move[:target_piece].properties.none?('leap') && blocking_piece?(move)

    if move[:target_piece].type == 'Pawn' && move[:target_piece].en_passant?(move, last_move, last_piece_abbvr)
      move[:en_passant] = true
    end

    possible_moves = move[:target_piece].filter_moves(move[:target_xy])
    return unless possible_moves.any?(move[:destination_xy])

    check?(move[:current_player])
    move[:destination_xy]
  end

  def blocking_piece?(move, current_space = Array.new(move[:target_xy]))
    return false if current_space.join('') == move[:destination_xy].join('')
    return true if spaces[current_space[0]][current_space[1]] && move[:target_xy].join('') != current_space.join('')

    new_x = if move[:destination_xy][0] > current_space[0]
              current_space[0] += 1
            elsif move[:destination_xy][0] < current_space[0]
              current_space[0] -= 1
            else
              current_space[0]
            end

    new_y = if move[:destination_xy][1] > current_space[1]
              current_space[1] += 1
            elsif move[:destination_xy][1] < current_space[1]
              current_space[1] -= 1
            else
              current_space[1]
            end

    blocking_piece?(move, [new_x, new_y])
  end

  def update_board(move)
    if @move_history.last
      last_target_xy = convert_input(@move_history.last[1..2]).join('')
      last_destination_xy = convert_input(@move_history.last[3..4]).join('')
      last_move = "#{last_target_xy}#{last_destination_xy}"
    end

    move[:target_piece].incr_move_count
    update_space(move[:target_xy], nil)
    update_space(move[:destination_xy], move[:target_piece])
    update_space([last_move[2].to_i, last_move[3].to_i], nil) if move[:en_passant]
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

  def check?(current_player)
    king_xy = get_coordinates(current_player, 'King')
  end

  def get_coordinates(player_index, piece_type)
    coordinates = nil
    @spaces.each_with_index do |column, col_index|
      column.each_with_index do |space, row_index|
        if space&.player_index == player_index && space&.type == piece_type
          coordinates = [col_index, row_index]
          break
        end
      end
      return coordinates if coordinates
    end
    coordinates
  end
end
