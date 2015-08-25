require_relative 'board'
require_relative 'player'
require_relative 'ai'
require 'yaml'

class Game
  def initialize(white_player_class, black_player_class)
    @colors = [:w, :b]
    @board = Board.new
    @players = [white_player_class.new(@board, @colors.first),
                black_player_class.new(@board, @colors.last)]
  end

  def switch_players!
    @players.reverse!
    @colors.reverse!
  end

  def take_turn
    player_input = @players.first.get_move
    # handle player request to save game
    while player_input.is_a?(String)
      save_game(player_input)
      puts "Game saved as #{player_input}!"
      sleep(0.5)
      @board.display
      player_input = @players.first.get_move
    end

    @board.make_move(player_input)
    @board.display
    switch_players!
  end

  def play
    @board.display
    take_turn until game_over?
    if checkmate?
      puts "Checkmate! #{self.class.color_to_string(@colors.last)} wins!"
    else
      puts "It's a draw!"
    end
  end

  def game_over?
    @colors.any? { |color| @board.checkmate?(color) || @board.stalemate?(color)}
  end

  def checkmate?
    @colors.any? { |color| @board.checkmate?(color) }
  end

  def self.color_to_string color
    color == :b ? "Black" : "White"
  end

  def self.set_up_game
    puts "What type of game would you prefer? "
    puts "1 Human vs Human"
    puts "2 Human vs Computer"
    puts "3 Computer vs Human"
    puts "4 Computer vs Computer"
    puts "5 Load Game"
    # input = nil
    begin
      input = gets.to_i
      raise RangeError unless input.between?(1, 5)
    rescue
      puts "Enter a number between 1 and 5: "
      retry
    end
    case input
    when 1
      Game.new(Player, Player).play
    when 2
      Game.new(Player, AI).play
    when 3
      Game.new(AI, Player).play
    when 4
      Game.new(AI, AI).play
    when 5
      begin
        Game.load_game(Game.get_load_file_name)
      rescue
        puts "That is not a valid filename, try again"
        retry
      end
    end
  end

  def save_game(filename)
    f = File.new(filename, "w")
    f.print self.to_yaml
    f.close
  end

  def self.load_game(filename)
    raise NameError unless File.exist?(filename)
    YAML.load_file(filename).play
  end

  def self.get_load_file_name
    puts "Enter the name of the saved game file you'd like to load: "
    gets.chomp.downcase
  end
end

Game.set_up_game if __FILE__ == $PROGRAM_NAME
