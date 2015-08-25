class SteppingPiece < Piece
  def moves
    moves = []
    move_diffs.each do |diff|
      new_pos = @position
      new_pos = [new_pos[0] + diff[0], new_pos[1] + diff[1]]
      moves << new_pos unless @board.hit_object?(new_pos, @color)
    end

    moves
  end

  def move_diffs
    puts "this is the SteppingPiece superclass"
  end
end
