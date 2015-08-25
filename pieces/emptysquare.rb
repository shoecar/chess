class EmptySquare
  def initialize
  end

  def to_s
    " "
  end

  def empty?
    true
  end

  def moves
    raise "this is an empty square"
  end
end
