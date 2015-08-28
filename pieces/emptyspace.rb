class EmptySpace
  attr_accessor :pos
  attr_reader :symbol, :color

  def initialize(pos)
    @symbol = " "
    @color = "Empty"
    @pos = pos
  end

  def moves
    []
  end

  def valid_moves
    []
  end

  def dupe(board)
    self.class.new(pos.dup)
  end
end
