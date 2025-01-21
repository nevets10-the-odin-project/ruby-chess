require_relative 'piece'

class Pawn < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♙' : '♟'
    super('Pawn', player_index, piece_index, icon)
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

  def valid_move?(target_xy, destination_xy, destination_piece, last_move)
    return false if destination_piece && destination_xy[0] == target_xy[0]
    return false if !destination_piece && destination_xy[0] != target_xy[0]
    return false if target_xy[0] != destination_xy[0] && en_passant?(destination_xy, last_move)

    true
  end

  def en_passant?(destination_xy, last_move)
    true if last_move[1].match?(/(([0-7])(2)\2(4)|([0-7])(7)\5(5))/) && last_move[0] == destination_xy[0]
  end
end
