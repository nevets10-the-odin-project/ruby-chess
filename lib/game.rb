require_relative 'board'
require_relative 'player'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'pawn'

class Game
  def initialize
    board = Board.new(init_pieces)
    players = [Player.new('White'), Player.new('Black')]
    current_player = 0
  end
end
