require_relative 'sliding_piece.rb'

class Bishop < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2657" : "\u265D"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    DIAGONAL_DIRECTIONS
  end
end
