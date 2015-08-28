require 'io/console'

class Player
  attr_accessor :color
  attr_reader :name

  def initialize(name)
    @name = name
    @color = nil
  end

  def get_cursor_movement
    $stdin.getch
  end

end
