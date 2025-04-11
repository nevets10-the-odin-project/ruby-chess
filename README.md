# Project: Ruby Final Project - Chess

https://www.theodinproject.com/lessons/ruby-ruby-final-project

## Introduction

You’ve come a long way. Now it’s time to prove how much you’ve learned.

Chess is a classic game that appears very complicated at first but can be broken down into logical steps that make it a great Ruby capstone project. If you’ve never played, be sure to read up on the rules (see the Chess [Wikipedia Page](https://en.wikipedia.org/wiki/Chess)) first.

The problem specification is deliberately sparse for this, your final project of Ruby – it’s up to you to attack the problem with very little prior information or structure, which is good practice for real world programming challenges. You have all the tools you need. You already did a lot of the heavy thinking in the [Knight’s Travails project](https://github.com/nevets10-the-odin-project/knights-travails).

The main difference is that this problem has the broadest scope of anything you’ve done yet. The keys here will be thinking it through logically ahead of time and maintaining a disciplined workflow. It’ll be much easier on you if you’re able to stay organized and break it down into components that you can tackle one by one.

This is a great project to have as a part of your portfolio going forward because it shows you can take on something with a lot of different components to it.

## How to Play

Enter the space coordinates of the piece you want to move and the destination. (a2a4)

If you want to perform a castling move, enter the space coordinates plus 'c'. (e1c1c)

## Post project review

This was definitely not an easy project and I feel that it started coming undone about half way through. The Board class is gargantuan and I could probably spend just a long refactoring it as it took to write up till now. Despite that, I believe I have everything implemented, including En Passant and Castling. There are no check for stalemates.

The only thing I am willingly omitting is the testing. I understand the importance of testing. However, the rspec content is by far the weakest in this curriculum (as of 01/27/2025) and it really only focused on unit tests instead of wider-scale testing. It's definitely what I have struggled with the most so far.

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
- Player
    - Variables
        - color - The player's color
