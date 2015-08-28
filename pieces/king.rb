require_relative 'stepping_piece.rb'

class King < SteppingPiece

  def initialize(board, pos, color)
    super
    @symbol = color == "white" ? "\u2654" : "\u265A"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    KING_DIRECTIONS
  end
end
