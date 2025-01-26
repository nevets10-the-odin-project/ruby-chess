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
      # system 'clear -x'
      board.print_board
      break if board.checkmate?(@current_player)

      puts "It's #{players[@current_player].color}'s turn!"
      input = player_input
      piece_abbreviation = board.piece_abbreviation(input[:user_input])
      board.update_board(input[:move])
      board.update_move_history(piece_abbreviation + input[:user_input])
      castling = input[4]
      player.update_castle if castling

      @current_player = @current_player >= 1 ? 0 : 1
    end

    puts 'Checkmate!'
  end

  def player_input
    loop do
      user_input = gets.chomp
      validated_input = validate_input(user_input)
      return { user_input: user_input, move: validated_input } if validated_input

      puts 'Illegal move.'
    end
  end

  def validate_input(user_input)
    target = user_input[0, 2]
    destination = user_input[2, 2]
    castling = user_input[4]

    return unless target.match?(/[a-h][1-8]/)
    return unless destination.match?(/[a-h][1-8]/)

    move = board.generate_move(target, destination, castling, @current_player)
    move if board.validate_move(move)
  end

  def game_over?
    false
  end
end
