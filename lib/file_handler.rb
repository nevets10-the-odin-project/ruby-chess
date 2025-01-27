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
                board_spaces: serialize_spaces(game.board.spaces),
                move_history: game.board.move_history
              })
  end

  def serialize_spaces(spaces)
    serialized = []
    spaces.each_with_index do |col, col_index|
      col.each_with_index do |space, row_index|
        serialized << if space
                        {
                          type: space.type,
                          player_index: space.player_index,
                          piece_index: space.piece_index,
                          move_count: space.move_count
                        }
                      end
      end
    end
    serialized
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
