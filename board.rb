require_relative 'pieces/pieces'
require 'colorize'

class Board
  attr_accessor :selected_square
  attr_reader :cursor

  def initialize(set_up_pieces = true)
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    populate if set_up_pieces
    @cursor = [4, 4]
    @selected_square = nil
    @captured_pieces = []
  end

  def populate
    @grid[0] = other_pieces(:b, 0)
    @grid[1] = pawn_row(:b, 1)
    @grid[6] = pawn_row(:w, 6)
    @grid[7] = other_pieces(:w, 7)
  end

  def pawn_row(color, row)
    Array.new(8) { |col| Pawn.new(color, [row, col], self) }
  end

  def other_pieces(color, row)
    row_array = Array.new(8)

    (0..2).each do |col|
      if col == 0
        type = Rook
      elsif col == 1
        type = Knight
      else
        type = Bishop
      end
      row_array[col] = type.new(color, [row, col], self)
      row_array[7 - col] = type.new(color, [row, 7 - col], self)
    end

    row_array[3] = Queen.new(color, [row, 3], self)
    row_array[4] = King.new(color, [row, 4], self)

    row_array
  end

  def [](position)
    row, col = position
    @grid[row][col]
  end

  def []=(pos, thing)
    row, col = pos
    @grid[row][col] = thing
  end

  def move_cursor(dir)
    new_cursor = [@cursor[0] + dir[0], @cursor[1] + dir[1]]
    @cursor = new_cursor unless off_board?(new_cursor)
  end

  def hit_enemy_piece?(pos, color)
    return false if off_board?(pos)
    occupied?(pos) && self[pos].color != color
  end

  def hit_object?(pos, color)
    return true if off_board?(pos)
    occupied?(pos) && self[pos].color == color
  end

  def occupied?(pos)
    !self[pos].empty?
  end

  def off_board?(pos)
    pos.any? { |el| !el.between?(0, 7) }
  end

  def display
    system('clear')
    highlights = []
    if selected_square
      highlights = valid_piece_moves(self[selected_square]) << selected_square
    end

    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        bg_color = get_bg_color([row_idx, col_idx], highlights)
        print (square.to_s + " ").colorize(:background => bg_color)
      end
      case row_idx
      when 1
        display_captured_pieces(:w)
      when 3
        print " Press 'k' to save your game."
      when 4
        print " Press 'esc' to quit."
      when 6
        display_captured_pieces(:b)
      end
      puts
    end
  end

  def display_captured_pieces(color)
    print " "
    @captured_pieces.each do |piece|
      if piece.color == color
        print color == :b ? (piece.to_s + " ").on_white : (piece.to_s + " ")
      end
    end
  end

  def get_bg_color(pos, highlights)
    if pos == cursor
      :green
    # highlight possible moves in yellow and possible captures in purple
    elsif highlights.include?(pos)
      if occupied?(pos) && self[pos].color != self[selected_square].color
        :light_magenta
      else
        :yellow
      end
    # non-highlighted squares should alternate colors
    else
      pos.inject(:+).even? ? :red : :blue
    end
  end

  def make_move(positions)
    start_pos, move_to = positions
    @captured_pieces << self[move_to] unless self[move_to].empty?
    self[start_pos].position = move_to
    self[start_pos], self[move_to] = EmptySquare.new, self[start_pos]
  end

  def valid_move?(positions, color)
    start_pos, move_to = positions

    return false unless self[start_pos].moves.include?(move_to)

    enemy_piece = self[move_to] if hit_enemy_piece?(move_to, color)
    make_move([start_pos, move_to])
    in_check = check?(color)
    make_move([move_to, start_pos])

    if enemy_piece
      self[move_to] = enemy_piece
      @captured_pieces.pop
    end

    !in_check
  end

  def valid_piece_moves(piece)
    piece.moves.select do |move|
      valid_move?([piece.position, move], piece.color)
    end
  end

  def check?(color)
    enemy_moves = []
    king_pos = nil
    @grid.flatten.each do |piece|
      unless piece.empty?
        enemy_moves += piece.moves unless piece.color == color
        king_pos = piece.position if piece.is_a?(King) && piece.color == color
      end
    end
    enemy_moves.include?(king_pos)
  end

  def checkmate?(color)
    if check?(color)
      valid_moves(color).empty?
    else
      false
    end
  end

  def stalemate?(color)
    valid_moves(color).empty?
  end

  def valid_moves(color)
    get_friendly_pieces(color).inject([]) do |valid_moves, piece|
      valid_moves + valid_piece_moves(piece)
    end
  end

  def get_friendly_pieces(color)
    pieces = []
    @grid.flatten.each do |piece|
      pieces << piece if !piece.empty? && piece.color == color
    end
    pieces
  end

  def dup_board
    new_board = Board.new(false)
    (0..7).each do |row_idx|
      (0..7).each do |col_idx|
        current_square = self[[row_idx, col_idx]]
        unless current_square.empty?
          new_piece = copy_piece(current_square, new_board)
          new_board[[row_idx, col_idx]] = new_piece
        end
      end
    end
    new_board
  end

  def copy_piece(piece, new_board)
    piece.class.new(piece.color, piece.position, new_board)
  end
end
