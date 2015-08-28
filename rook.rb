require_relative 'sliding_piece.rb'

class Rook < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = color == "white" ? "\u2656" : "\u265C"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    ORTHOGONAL_DIRECTIONS
  end
end
