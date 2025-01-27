require 'json'

class File_handler
  def open_file(file_name)
    file = File.open(file_name)

    words = []

    while line = file.gets
      words << line
    end

    file.close

    words
  end

  def to_json(game)
    JSON.dump({
                current_player: game.current_player,
                board_spaces: game.board.spaces,
                move_history: game.board.move_history
              })
  end

  def save(game)
    file = File.open('save.txt', 'w')
    file.puts to_json(game)
    file.close
  end

  def load
    file = File.open('save.txt')
    data = JSON.load(file)
    file.close
    data
  end
end
