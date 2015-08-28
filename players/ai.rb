class AI
  attr_accessor :color
  attr_reader :name, :board

  def initialize(name, board)
    @board = board
    @name = name
    @color = nil
  end

  def get_valid_input
    sleep(1)
    all_positions = board.all_color_positions(self.color)
    opponent_positions = board.all_color_positions(board.other_color(self.color))
    all_positions.each do |position|
      board[position].moves.each do |move|
         if !board[position].move_into_check?(move) && opponent_positions.include?(move)
           return [position,move]
         end
      end
    end

    get_random_move(all_positions)

  end

  def get_random_move(all_positions)
    random_position = all_positions.sample
    random_piece = board[random_position]

    random_move = random_piece.moves.sample

    if random_move.nil?
      get_random_move(all_positions)
    else
      [random_position,random_move]
    end
  end

end
