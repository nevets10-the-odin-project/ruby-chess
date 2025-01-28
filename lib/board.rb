require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'pawn'

class Board
  attr_reader :spaces, :pieces, :move, :move_history

  BOARD_COLUMNS = %w[a b c d e f g h].freeze

  def initialize(data)
    if data.instance_of?(Hash)
      @spaces = load_spaces(data['board_spaces'])
      @move_history = data['move_history']
    else
      @spaces = build_spaces(data)
      @move_history = []
    end
  end

  def load_spaces(spaces)
    board = []

    8.times do
      tracker = 0
      column = spaces.slice!(tracker, tracker + 8)
      board << import_column(column)
    end

    board
  end

  def import_column(data)
    column = []
    data.each do |space|
      column << if space
                  case space['type']
                  when 'Pawn'
                    Pawn.new(space['player_index'], space['piece_index'], space['move_count'])
                  when 'Rook'
                    Rook.new(space['player_index'], space['piece_index'], space['move_count'])
                  when 'Knight'
                    Knight.new(space['player_index'], space['piece_index'], space['move_count'])
                  when 'Bishop'
                    Bishop.new(space['player_index'], space['piece_index'], space['move_count'])
                  when 'Queen'
                    Queen.new(space['player_index'], space['piece_index'], space['move_count'])
                  when 'King'
                    King.new(space['player_index'], space['piece_index'], space['move_count'])
                  end
                end
    end
    column
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
    if input.instance_of?(String)
      x_coord = BOARD_COLUMNS.index(input[0])
      y_coord = input[1].to_i - 1
    else
      x_coord = input[0]
      y_coord = input[1]
    end

    [x_coord, y_coord]
  end

  def generate_move(target, destination, castling, current_player)
    {
      target_xy: convert_input(target),
      destination_xy: convert_input(destination),
      target_piece: @spaces[convert_input(target)[0]][convert_input(target)[1]],
      destination_piece: @spaces[convert_input(destination)[0]][convert_input(destination)[1]],
      current_player: current_player,
      castling: castling == 'c' && @spaces[convert_input(target)[0]][convert_input(target)[1]].type == 'King',
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

    return if move[:target_piece].type == 'King' && move[:castling] && !valid_castling?(move)

    possible_moves = move[:target_piece].filter_moves(move[:target_xy])
    return unless possible_moves.any?(move[:destination_xy])
    return if check?(move[:current_player]) && !break_check?(move)

    # return if check?(move[:current_player]) && move[:target_piece].type != 'King'

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

  def break_check?(move)
    update_space(move[:destination_xy], move[:target_piece])
    is_checked = check?(move[:current_player])
    update_space(move[:destination_xy], move[:destination_piece])
    !is_checked
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
    pawn_promotion(move) if move[:target_piece].type == 'Pawn'
    return unless move[:castling]

    update_castling_rook(move)
  end

  def pawn_promotion(move)
    max_queen_index = get_max_piece_index(move, 'Queen')

    if move[:current_player] == 0 && move[:destination_xy][1] == 7
      queen_index = max_queen_index + 1 || 0
      update_space(move[:destination_xy], Queen.new(0, queen_index + 1))
    elsif move[:current_player] == 1 && move[:destination_xy][1] == 0
      queen_index = max_queen_index + 1 || 0
      update_space(move[:destination_xy], Queen.new(0, queen_index + 1))
    end
  end

  def get_max_piece_index(move, type)
    cur_pieces = []
    spaces.each do |col|
      col.each do |space|
        cur_pieces << space if space&.player_index == move[:current_player] && space&.type == type
      end
    end
    cur_pieces.reduce(0) do |acc, cur|
      cur.piece_index if cur.piece_index > acc
      acc
    end
  end

  def update_castling_rook(move)
    rook_index = move[:destination_xy][0] < move[:target_xy][0] ? 0 : 1
    rook_coord = get_coordinates(move[:current_player], 'Rook', rook_index)
    rook_piece = @spaces[rook_coord[0]][rook_coord[1]]
    rook_piece.incr_move_count
    rook_x = move[:destination_xy][0] < move[:target_xy][0] ? move[:target_xy][0] - 1 : move[:target_xy][0] + 1
    new_rook_space = [rook_x, move[:target_xy][1]]

    update_space(new_rook_space, rook_piece)
    update_space(rook_coord, nil)
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

  def check?(current_player, king_xy = get_coordinates(current_player, 'King'))
    other_player = current_player >= 1 ? 0 : 1
    opponent = opponent_pieces(current_player)

    is_check = false

    opponent.each do |piece|
      coord = get_coordinates(other_player, piece.type, piece.piece_index)
      move = generate_move(coord, king_xy, nil, other_player)
      is_check = true if validate_move(move)
    end

    is_check
  end

  def valid_castling?(move)
    return false unless move[:target_piece].move_count.zero?

    rook_index = move[:destination_xy][0] < move[:target_xy][0] ? 0 : 1
    rook_coord = get_coordinates(move[:current_player], 'Rook', rook_index)
    rook_piece = @spaces[rook_coord[0]][rook_coord[1]]
    return false unless rook_piece.move_count.zero?

    rook_move = generate_move(rook_coord, move[:target_xy], nil, move[:current_player])
    return false if blocking_piece?(rook_move)

    true
  end

  def checkmate?(current_player)
    return false unless check?(current_player)

    king_xy = get_coordinates(current_player, 'King')
    king_piece = @spaces[king_xy[0]][king_xy[1]]
    valid_moves = validated_moves(king_piece, king_xy, current_player)

    check_counter = 0
    valid_moves.each do |possible_xy|
      check_counter += 1 if check?(current_player, possible_xy)
    end

    check_counter == valid_moves.length
  end

  def validated_moves(piece, piece_xy, current_player)
    available_moves = piece.filter_moves(piece_xy)
    moves = []
    available_moves.each do |destination|
      move = generate_move(piece_xy, destination, nil, current_player)
      moves << validate_move(move) if validate_move(move)
    end
    moves
  end

  def get_coordinates(player_index, piece_type, piece_index = 0)
    coordinates = nil
    @spaces.each_with_index do |column, col_index|
      column.each_with_index do |space, row_index|
        next unless space

        if space.player_index == player_index && space.type == piece_type && space.piece_index == piece_index
          coordinates = [col_index, row_index]
          break
        end
      end
      return coordinates if coordinates
    end
    coordinates
  end

  def opponent_pieces(cur_player)
    pieces = []
    @spaces.each do |column|
      column.each do |space|
        pieces << space if space && space.player_index != cur_player
      end
    end
    pieces
  end
end
