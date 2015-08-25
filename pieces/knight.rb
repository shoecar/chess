require 'colorize'

class Knight < SteppingPiece
  def move_diffs
    [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]
  end

  def to_s
    @color == :b ? "♞".black : "♞"
  end
end
