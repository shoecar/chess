require 'colorize'

class Pawn < Piece
  def moves
    direction = (@color == :b ? 1 : -1)
    forward_moves(direction) + diagonal_moves(direction)
  end

  def to_s
    @color == :b ? "♟".black : "♟"
  end

  private

  def forward_moves(direction)
    moves = []
    row, col = @position
    moved = (@color == :b ? row != 1 : row != 6)

    # move one space forward
    new_pos = [row + 1 * direction, col]
    unless @board.off_board?(new_pos) || @board.occupied?(new_pos)
      moves << new_pos

      # move 2 spaces forward (only if moving 1 space works)
      new_pos = [row + 2 * direction, col]
      unless @board.off_board?(new_pos) || @board.occupied?(new_pos) || moved
        moves << new_pos
      end
    end
    moves
  end

  def diagonal_moves(direction)
    moves = []
    [-1, 1].each do |i|
      new_pos = [@position[0] + 1 * direction, @position[1] + i]
      moves << new_pos if @board.hit_enemy_piece?(new_pos, @color)
    end
    moves
  end
end
