require_relative 'sliding_piece.rb'

class Queen < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2655" : "\u265B"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    DIAGONAL_DIRECTIONS + ORTHOGONAL_DIRECTIONS
  end
end
