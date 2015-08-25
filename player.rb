require 'io/console'

class Player
  def initialize(board, color)
    @board = board
    @color = color
    @positions = []
  end

  def get_move
    until @positions.size == 2
      puts "You're in check!" if @board.check?(@color)
      puts "#{Game.color_to_string(@color)}'s move"
      if @positions.size == 0
        puts "Press enter to select a piece."
      else
        puts "Press enter where you want to move, or enter on piece to deselect."
      end
      load_save = parse_input($stdin.getch)

      return load_save if load_save.is_a?(String)

      @board.display
    end

    # reset @positions and @board.selected_square
    move, @positions, @board.selected_square = @positions, [], nil
    move
  end

  def parse_input(input)
    case input
    # W-A-S-D move the cursor
    when "w"
      @board.move_cursor([-1,0])
    when "a"
      @board.move_cursor([0,-1])
    when "s"
      @board.move_cursor([1,0])
    when "d"
      @board.move_cursor([0,1])

    # K to save
    when "k"
      puts "What would you like to save your file as?"
      return gets.chomp.downcase
    when "\e"
      exit

    # return stores the current position
    # if it's the second stored position and a valid move, make the move.
    # if the second stored position is the same as the first one, deselect
    # the first position instead.
    when "\r"
      if @positions.count == 0
        if @board.hit_object?(@board.cursor, @color)
          @positions << @board.cursor
          @board.selected_square = @positions[0]
        end
      elsif @board.cursor == @positions[0]
        @positions = []
        @board.selected_square = nil
      else
        possible_move = @positions + [@board.cursor]
        if @board.valid_move?(possible_move, @color)
          @positions << @board.cursor
        end
      end

    # interrupt if ctrl-C pressed
    when "\u0003"
      raise Interrupt
    end
  end
end
