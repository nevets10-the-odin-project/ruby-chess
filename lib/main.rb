require_relative 'game'
require_relative 'file_handler'

file_handler = File_handler.new
puts 'load game? (y/N)'
do_load = gets.downcase.chomp
data = file_handler.load if do_load == 'y'
game = Game.new(data)

game.start
