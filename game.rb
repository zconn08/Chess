require './board/board.rb'
require './players/player.rb'
require './players/ai.rb'

class Game
  attr_reader :players, :player_one, :player_two, :board, :current_player

  def initialize()
    @board = Board.new
    setup
    player_one.color, player_two.color = "white", "black"
    @players = [player_one, player_two]
    @current_player = players.first
  end

  def setup
    system('clear')
    puts "Please select mode"
    puts "1. Human Vs. Human"
    puts "2. Human Vs. AI"
    puts "3. AI Vs. AI"
    input = gets.chomp.to_i
    if input == 1
      puts "Please enter Player 1's name"
      player1_name = gets.chomp
      puts "Please enter Player 2's name"
      player2_name = gets.chomp
      @player_one, @player_two = Player.new(player1_name, board), Player.new(player2_name, board)
    elsif input == 2
      puts "Please enter your name"
      player1_name = gets.chomp
      @player_one, @player_two = Player.new(player1_name, board), AI.new("Robot", board)
    elsif input == 3
      @player_one, @player_two = AI.new("Robot 1", board), AI.new("Robot 2", board)
    else
      puts "Please select 1, 2, or 3"
      sleep (1)
      setup
    end
  end

  def play
    begin
      until game_over?
        board.current_player = current_player
        take_turn
        rotate_players
      end
      system('clear')
      board.render
      puts "#{players.first.color.capitalize} is in checkmate!"
      puts "Game over! #{players.last.name} won!"
    rescue Interrupt => e
    end
  end

  def rotate_players
    @players.rotate!
    @current_player = players.first
  end

  def take_turn
    board.render_with_instructions

    begin
      move_positions = current_player.get_valid_input
      board.move!(move_positions)

    rescue MoveError => e
      puts e.message
      retry
    end
  end

  def game_over?
    board.game_over?
  end
end

game = Game.new
game.play
