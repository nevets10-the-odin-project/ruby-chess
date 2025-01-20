require_relative 'piece'

class Pawn < Piece
  def initialize(player_index, piece_index)
    icon = player_index.zero? ? '♙' : '♟'
    super('Pawn', player_index, piece_index, icon)
  end

  def filter_moves(current_position)
    x_dir = player_index.zero? ? 1 : -1
    one_space = [current_position[0] + (1 * x_dir), current_position[1]]
    two_spaces = [current_position[0] + (2 * x_dir), current_position[1]]
    l_attack = [current_position[0] + (1 * x_dir), current_position[1] - 1]
    r_attack = [current_position[0] + (1 * x_dir), current_position[1] + 1]
    # Omitting en-passant for now
    potential_moves = [one_space, two_spaces, l_attack, r_attack]

    potential_moves.filter { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end
end
