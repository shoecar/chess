require 'colorize'

class Bishop < SlidingPiece
  def move_dirs
    [[1,1],[1,-1],[-1,-1],[-1,1]]
  end

  def to_s
    @color == :b ? "♝".black : "♝"
  end
end
