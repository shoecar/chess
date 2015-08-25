require 'colorize'

class King < SteppingPiece
  def move_diffs
    [[1,0],[0,1],[1,1],[1,-1],[-1,0],[0,-1],[-1,-1],[-1,1]]
  end

  def to_s
    @color == :b ? "♚".black : "♚"
  end
end
