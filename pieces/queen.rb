require 'colorize'

class Queen < SlidingPiece
  def move_dirs
    [[1,0],[0,1],[1,1],[1,-1],[-1,0],[0,-1],[-1,-1],[-1,1]]
  end

  def to_s
    @color == :b ? "♛".black : "♛"
  end
end
