require_relative 'piece.rb'

class SlidingPiece < Piece
  ORTHOGONAL_DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]]
  DIAGONAL_DIRECTIONS = [[1, 1], [1, -1], [-1, -1], [-1, 1]]

  def initialize(board, pos, color)
    super
  end

  def moves(move_directions)
    potential_moves = []
    move_directions.each do |direction|
      potential_moves.concat(moves_in_dir(direction))
    end

    potential_moves
  end

  def moves_in_dir(direction)
    potential_moves = []

    x, y = pos
    dx, dy = direction
    (1...board.length).each do |i|
      possible_position = [x + (dx * i), y + (dy * i)]

      break unless can_move?(possible_position)

      potential_moves << possible_position
      break if check_enemy_color(possible_position)
    end

    potential_moves
  end
end
