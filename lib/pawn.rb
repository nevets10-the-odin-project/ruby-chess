require_relative 'piece'

class Pawn < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♙' : '♟'
    super('Pawn', player_index, piece_index, icon, 'p')
  end

  def filter_moves(current_position)
    y_dir = player_index.zero? ? 1 : -1
    one_space = [current_position[0], current_position[1] + (1 * y_dir)]
    two_spaces = [current_position[0], current_position[1] + (2 * y_dir)]
    l_attack = [current_position[0] - 1, current_position[1] + (1 * y_dir)]
    r_attack = [current_position[0] + 1, current_position[1] + (1 * y_dir)]
    potential_moves = [one_space, two_spaces, l_attack, r_attack]

    potential_moves.filter { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end

  def valid_move?(target_xy, destination_xy, destination_piece, last_move, last_piece_abbvr)
    p last_piece_abbvr
    p destination_xy
    p last_move
    return true if target_xy[0] != destination_xy[0] && en_passant?(destination_xy, last_move, last_piece_abbvr)
    return false if destination_piece && destination_xy[0] == target_xy[0]
    return false if !destination_piece && destination_xy[0] != target_xy[0]

    true
  end

  def en_passant?(destination_xy, last_move, last_piece_abbvr)
    p last_piece_abbvr == 'p'
    p last_move.match?(/(([0-7])(1)\2(3)|([0-7])(6)\5(4))/)
    p last_move[0] == destination_xy[0]
    last_piece_abbvr == 'p' && last_move.match?(/(([0-7])(1)\2(3)|([0-7])(6)\5(4))/) && last_move[2].to_i == destination_xy[0]
  end
end
