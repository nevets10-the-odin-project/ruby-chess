# ruby-chess
[Project: Ruby Final Project - Chess](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

---

## Brainstorming

There is a ton of stuff needed for this game and I'm sure there are some things missing from the list below, but hopefully this is sufficient to at least get started.

Classes
- Game
    - Variables
        - board - Board object
        - players - Array of Player objects
        - current_player - Index of current player
        - player_selection(?) - I'm not sure if this is strictly needed for this game.
    - Methods
        - #initialize - Self explanatory        
        - #play_game - Loops over player turns until an end condition is met
        - #player_input - Gets player input
        - #validate_input - Validates player input
        - #game_over? - Checks for a game over condition
- Board
    - Variables
        - spaces - 2 dimensional array of spaces that make up the board
        - pieces - An array of pieces on the board
    - Methods
        - #initialize - Self explanatory
        - #build_board - Creates the spaces array
        - #update_board - Updates the board
        - #print_board - Prints the current layout of the board
        - #validate_moves - Validates possible moves for a piece
        - #check? - Checks if a King can be captured
        - #check_mate? - Checks if a King can be captured and there are no safe moves left
        - #draw? - Checks for a draw
- Piece
    - Variables
        - type - e.g. King, Queen, Rook, etc.        
        - player_index - The index of the player that the piece belongs to
        - icon - The icon of the piece
    - Methods
        - #moves - Passed to board#validate_moves, Returns an array of valid moves