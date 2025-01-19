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

  def init_pieces
    pieces = []
    (0..1).each do |player_index|
      pieces << King.new(player_index, 0)
      pieces << Queen.new(player_index, 0)

      (0..1).each do |piece_index|
        pieces << Rook.new(player_index, piece_index)
        pieces << Bishop.new(player_index, piece_index)
        pieces << Knight.new(player_index, piece_index)
      end

      (0..7).each { |piece_index| pieces << Pawn.new(player_index, piece_index) }
    end
  end
end
