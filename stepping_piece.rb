require_relative 'piece.rb'


class SteppingPiece < Piece
  KING_DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0],
                     [1, 1], [1, -1], [-1, -1], [-1, 1]]
  KNIGHT_DIRECTIONS = [[-2, -1], [-2, 1], [-1, -2], [-1, 2],
                       [1, -2], [1, 2], [2, -1], [2, 1]]

  def initialize(board, pos, color)
    super
  end

  def moves(move_directions)
    potential_moves = []

    x, y = pos
    move_directions.each do |direction|
      dx, dy = direction
      possible_position = [x + dx, y + dy]

      next unless can_move?(possible_position)

      potential_moves << possible_position
    end

    potential_moves
  end
end
