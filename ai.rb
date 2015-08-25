require 'io/console'

class AI
  PIECE_VALUE = {
                 King => 1337,
                 Queen => 18,
                 Rook => 10,
                 Knight => 6,
                 Bishop => 6,
                 Pawn => 2,
                 EmptySquare => 0
                 }

  ACTION_VALUE = {
                  :checkmate => 9999,
                  :check => 1
                  }

  def initialize(board, color)
    @board = board
    @color = color
  end

  def get_move
    possible_moves = []
    @board.get_friendly_pieces(@color).each do |piece|
      @board.valid_piece_moves(piece).each do |move|
        possible_moves << [piece.position, move]
      end
    end

    possible_moves.shuffle!

    net_values = []

    possible_moves.each do |positions|
      net_values << calculate_net_value(positions)
    end

    children_moves = []

    possible_moves.each do |positions|

    end

    possible_moves[net_values.index(net_values.max)]
  end

  private

  def calculate_net_value(positions, board = @board)
    start_pos, move_to = positions
    move_value = PIECE_VALUE[board[move_to].class]
    return ACTION_VALUE[:checkmate] if move_causes_checkmate?(positions)
    if board == @board
      move_value -= best_enemy_move_value(positions)
    end
    if move_causes_check?(positions)
      move_value += ACTION_VALUE[:check]
    end
    move_value
  end

  def move_causes_checkmate?(move_positions)
    test_board = test_move(move_positions)
    test_board.checkmate?(enemy_color(test_board[move_positions[1]]))
  end

  def move_causes_check?(move_positions)
    test_board = test_move(move_positions)
    test_board.check?(enemy_color(test_board[move_positions[1]]))
  end

  def best_enemy_move_value(move_positions)
    test_board = test_move(move_positions)

    enemy_color = enemy_color(test_board[move_positions[1]])

    enemy_pieces = test_board.get_friendly_pieces(enemy_color)

    enemy_moves = []
    enemy_pieces.each do |enemy_piece|
      test_board.valid_piece_moves(enemy_piece).each do |move|
        enemy_moves << [enemy_piece.position, move]
      end
    end

    enemy_moves.map do |enemy_move|
      calculate_net_value(enemy_move, test_board)
    end.max
  end

  def test_move(move_positions)
    test_board = @board.dup_board
    test_board.make_move(move_positions)
    test_board
  end

  def enemy_color(piece)
    piece.color == :b ? :w : :b
  end
end
