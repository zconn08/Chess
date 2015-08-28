require 'io/console'

class Player
  attr_accessor :color
  attr_reader :name, :board

  def initialize(name, board)
    @board = board
    @name = name
    @color = nil
  end

  def get_cursor_movement
    $stdin.getch
  end

  def get_valid_input
    board.current_selection = []
    move_positions = []
    while move_positions.count < 2 do
      # board.debugging_output
      movement = self.get_cursor_movement
      if movement == "\r" && valid_helper(move_positions)
        move_positions << board.cursor
        board.current_selection = board.cursor
      end

      board.move_cursor(movement)
      board.render_with_instructions
    end

    if move_positions.uniq.count == 1 || !board[move_positions[0]].moves.include?(move_positions[1])
      move_positions = get_valid_input
    end
    board.current_selection = []
    move_positions
  end

  def valid_helper(arr)
    (board.occupied? && selected_right_color) || (arr.length == 1)
  end

  def selected_right_color
    board.all_color_positions(self.color).include?(board.cursor)
  end

end
