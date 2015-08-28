require_relative 'stepping_piece.rb'

class Knight < SteppingPiece

  def initialize(board, pos, color)
    super
    @symbol = color == "white" ? "\u2658" : "\u265E"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    KNIGHT_DIRECTIONS
  end
end
