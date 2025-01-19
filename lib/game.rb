require_relative 'board'
require_relative 'player'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'pawn'

class Game
  attr_reader :board, :players, :current_player

  def initialize
    @board = Board.new(init_pieces)
    @players = [Player.new('White'), Player.new('Black')]
    @current_player = 0
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
    pieces
  end

  def start
    loop do
      system 'clear -x'
      puts
      puts "It's #{players[current_player].color}'s turn!"
      input = player_input

      break if game_over?

      @current_player = @current_player >= 1 ? 0 : 1
    end
  end

  def game_over?
    false
  end
end
