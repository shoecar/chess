class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def inspect
    {
      color: @color,
      pos: @position
    }
  end

  def moves
    raise NotImplementedError.new
  end

  def empty?
    false
  end
end
