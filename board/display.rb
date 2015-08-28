module Display

  MOVES = {
    "a" => [0, -1],
    "s" => [1, 0],
    "d" => [0, 1],
    "w" => [-1, 0]
  }

  def move_cursor(player_input)
    exit if player_input == "q"
    direction = MOVES[player_input]
    unless direction.nil?
      x, y = cursor
      dx, dy = direction
      potential_x, potential_y = cursor[0] + dx, cursor[1] + dy
      @cursor = [potential_x, potential_y] if on_board?([potential_x,potential_y])
    end
  end

  def debugging_output
    puts "Cursor: #{@cursor}"
    puts "Position: #{self[@cursor].pos}"
    puts "Valid Moves: #{self[@cursor].valid_moves}"
    puts "White King: #{self.king_position("white")}"
    puts "Black King: #{self.king_position("black")}"
    puts "In check? White: #{self.in_check?("white")}"
    puts "In check? Black: #{self.in_check?("black")}"
    puts "Checkmate White: #{self.check_mate?("white")}"
    puts "Checkmate Black: #{self.check_mate?("black")}"
  end
end
