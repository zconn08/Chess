require_relative 'display.rb'
require_relative 'errors.rb'
require './pieces/pieces.rb'
require 'colorize'
require 'byebug'

class Board
  attr_accessor :board, :cursor, :current_selection, :current_player
  attr_reader :killed_pieces

  include Display

  PIECE_ORDER = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  def self.blank_board
    Board.new(false)
  end

  def initialize(populate = true)
    @board = Array.new(8) { Array.new(8) }
    @cursor = [0,0]
    @killed_pieces = []
    @current_selection = []
    @current_player
    populate_board if populate
  end

  def [](pos)
    x, y = pos
    board[x][y]
  end

  def []=(pos,value)
    x, y = pos
    @board[x][y] = value
  end

  def populate_board
    board.each_with_index do |row, i|
      row.each_index do |j|
        pos = [i, j]
        if i == 0
          self[pos] = PIECE_ORDER[j].new(self, pos, "white")
        elsif i == 1
          self[pos] = Pawn.new(self, pos, "white")
        elsif i == 6
          self[pos] = Pawn.new(self, pos, "black")
        elsif i == 7
          self[pos] = PIECE_ORDER[j].new(self, pos, "black")
        else
          self[pos] = EmptySpace.new(pos)
        end
      end
    end
  end

  def render
    puts "   a  b  c  d  e  f  g  h "
    board.each_with_index do |row,i|
      print "#{i+1} "
      row.each_with_index do |cell,j|
        if [i,j] == cursor
          print " #{cell.symbol} ".colorize(background: :yellow)
        elsif [i,j] == current_selection
          print " #{cell.symbol} ".colorize(background: :light_black)
        elsif !current_selection.empty? && self[current_selection].valid_moves.include?([i,j])
          print " #{cell.symbol} ".colorize(background: :green)
        elsif current_selection.empty? && self[cursor].valid_moves.include?([i,j]) && self[cursor].color == current_player.color
          print " #{cell.symbol} ".colorize(background: :green)
        elsif (i.odd? && j.even?) || (i.even? && j.odd?)
          print " #{cell.symbol} ".colorize(background: :red)
        else
          print " #{cell.symbol} ".colorize(background: :blue)
        end
      end
      puts
    end
    puts killed_pieces.join(" ")
  end

  def render_with_instructions
    system('clear')
    self.render
    puts "Please make a move #{@current_player.name}. Your color is #{@current_player.color}"
    puts "#{@current_player.color.capitalize} is in check".colorize(color: :red) if self.in_check?(@current_player.color)
    puts "______________________________________________________"
    puts "Instructions:"
    puts "Please use WASD to navigate and Enter to select."
    print "Cancel a move by selecting the same piece twice, "
    if @current_player.class == Player
      puts "push Q to quit"
    else
      puts "push CTRL + C to quit"
    end
  end

  def move(movement)
    start_pos, end_pos = movement
    if self[start_pos].moves.include?(end_pos)
      unless empty_space?(end_pos)
          @killed_pieces << self[end_pos].symbol
          self[end_pos] = EmptySpace.new(end_pos)
      end

      self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
      self[start_pos].pos, self[end_pos].pos = self[end_pos].pos, self[start_pos].pos
      self[end_pos].moved = true if self[end_pos].is_a?(Pawn)
    end
  end

  def move!(movement)
    start_pos, end_pos = movement
    if self[start_pos].move_into_check?(end_pos)
      raise MoveError.new("Cannot make that move")
    else
      move(movement)
    end

  end

  def king_position(color)
    board.each_with_index do |row,i|
      row.each_with_index do |cell,j|
        return [i,j] if cell.is_a?(King) && cell.color == color
      end
    end
  end

  def all_color_moves(color)
    all_color_moves = []
    board.flatten.each do |cell|
      all_color_moves.concat(cell.moves) if cell.color == color
    end

    all_color_moves
  end

  def all_color_positions(color)
    all_color_positions = []
    board.flatten.each do |cell|
      all_color_positions << cell.pos if cell.color == color
    end

    all_color_positions
  end

  def in_check?(color)
    all_color_moves(other_color(color)).include?(king_position(color))
  end

  def check_mate?(color)
    all_color_pieces = board.flatten.select { |cell| cell.color == color }
    all_color_pieces.all? { |cell| cell.valid_moves.empty? }
  end

  def other_color(color)
    color == "white" ? "black" : "white"
  end

  def deep_dup
    blank_board = Board.blank_board
    board.each_with_index do |row,i|
      row.each_with_index do |cell,j|
        blank_board[[i,j]] = cell.dupe(blank_board)
      end
    end

    blank_board
  end

  def on_board?(pos)
    pos.all? { |value| value.between?(0,7) }
  end

  def empty_space?(pos)
    self[pos].is_a?(EmptySpace)
  end

  def occupied?
    !empty_space?(@cursor)
  end

  def length
    board.length
  end

  def game_over?
    check_mate?("white") || check_mate?("black")
  end
end
