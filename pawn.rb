require_relative 'piece.rb'

class Pawn < Piece
  PAWN_DIRECTIONS = [[1, 0], [2, 0]]
  PAWN_KILL_DIRECTIONS = [[1, 1], [1, -1]]

  attr_accessor :moved

  def initialize(board, pos, color, moved = false)
    super(board, pos, color)
    @moved = moved
    @symbol = color == "white" ? "\u2659" : "\u265F"
  end

  def dupe(board)
    self.class.new(board, pos.dup, color, moved)
  end

  def moved?
    moved
  end

  def moves
    non_kill_moves + kill_moves
  end

  def non_kill_moves
    potential_non_kill_moves = []

    x, y = pos
    color_change(pawn_vectors).each do |dx, dy|
      possible_position = [x + dx, y + dy]
      next unless board.on_board?(possible_position) && board.empty_space?(possible_position)
      potential_non_kill_moves << possible_position
    end

    potential_non_kill_moves
  end

  def kill_moves
    potential_kill_moves = []

    x, y = pos
    color_change(PAWN_KILL_DIRECTIONS).each do |dx, dy|
      possible_position = [x + dx, y + dy]
      next unless board.on_board?(possible_position)
      if check_enemy_color(possible_position) && !board.empty_space?(possible_position)
        potential_kill_moves << possible_position
      end
    end

    potential_kill_moves
  end

  def pawn_vectors
    moved? ? PAWN_DIRECTIONS.take(1) : PAWN_DIRECTIONS
  end

  def color_change(current_moves)
    current_moves.map do |dx, dy|
      color == "black" ? [dx * -1, dy * -1] : [dx, dy]
    end
  end
end
