class Piece
  attr_accessor :pos, :symbol
  attr_reader :color, :board

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @symbol = nil
  end

  def check_enemy_color(pos)
    !board[pos].is_a?(EmptySpace) && board[pos].color != color
  end

  def dupe(board)
    self.class.new(board, pos.dup, color)
  end

  def can_move?(pos)
    return false unless board.on_board?(pos)
    board.empty_space?(pos) || check_enemy_color(pos)
  end

  def move_into_check?(end_pos)
    duped_board = board.deep_dup
    duped_board.move([pos, end_pos])
    duped_board.in_check?(color)
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end
end
