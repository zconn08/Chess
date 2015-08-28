require_relative 'board.rb'
require_relative 'player.rb'

class Game
  attr_reader :players, :player_one, :player_two, :board, :current_player

  def initialize(player1, player2)
    @player_one, @player_two = Player.new(player1), Player.new(player2)
    player_one.color, player_two.color = "white", "black"
    @board = Board.new
    @players = [player_one, player_two]
    @current_player = players.first
  end

  def play
    until game_over?
      board.current_player = current_player
      take_turn
      rotate_players
    end
    system('clear')
    board.render
    puts "#{players.first.color.capitalize} is in checkmate!"
    puts "Game over! #{players.last.name} won!"
  end

  def rotate_players
    @players.rotate!
    @current_player = players.first
  end

  def take_turn
    render_with_instructions

    begin
      move_positions = get_valid_input
      board.move!(move_positions)

    rescue MoveError => e
      puts e.message
      retry
    end
  end

  def get_valid_input
    board.current_selection = []
    move_positions = []
    while move_positions.count < 2 do
      #@board.debugging_output
      movement = @current_player.get_cursor_movement
      if movement == "\r" && valid_helper(move_positions)
        move_positions << board.cursor
        board.current_selection = board.cursor
      end

      board.move_cursor(movement)
      render_with_instructions
    end

    if move_positions.uniq.count == 1 || !board[move_positions[0]].moves.include?(move_positions[1])
      move_positions = get_valid_input
    end
    board.current_selection = []
    move_positions
  end

  def valid_helper(arr)
    (board.occupied? && selected_right_color) || (arr.length == 1)
  end

  def selected_right_color
    board.all_color_positions(@current_player.color).include?(board.cursor)
  end

  def render_with_instructions
    system('clear')
    board.render
    puts "Please make a move #{@current_player.name}. Your color is #{@current_player.color}"
    puts "#{@current_player.color.capitalize} is in check".colorize(color: :red) if board.in_check?(@current_player.color)
    puts "______________________________________________________"
    puts "Instructions:"
    puts "Please use WASD to navigate and Enter to select."
    puts "Cancel a move by selecting the same piece twice, push Q to quit"
  end

  def game_over?
    board.game_over?
  end
end

game = Game.new("Player 1","Player 2")
game.play
