class SlidingPiece < Piece
  def moves
    moves = []
    move_dirs.each do |direction|
      new_pos = @position
      until @board.hit_enemy_piece?(new_pos, @color)
        new_pos = [new_pos[0] + direction[0], new_pos[1] + direction[1]]
        break if @board.hit_object?(new_pos, @color)
        moves << new_pos
      end
    end

    moves
  end

  def move_dirs
    raise NotImplementedError.new
  end
end
