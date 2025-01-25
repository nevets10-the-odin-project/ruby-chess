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

  def valid_move?(move, last_move, last_piece_abbvr)
    return true if en_passant?(move, last_move, last_piece_abbvr)
    return false if move[:destination_piece] && move[:destination_xy][0] == move[:target_xy][0]
    return false if !move[:destination_piece] && move[:destination_xy][0] != move[:target_xy][0]

    true
  end

  def en_passant?(move, last_move, last_piece_abbvr)
    return unless last_move

    move[:target_xy][0] != move[:destination_xy][0] && last_piece_abbvr == 'p' && last_move.match?(/(([0-7])(1)\2(3)|([0-7])(6)\5(4))/) && last_move[2].to_i == move[:destination_xy][0]
  end
end
