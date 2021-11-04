class Board
  attr_accessor :board, :white_king, :black_king
  def initialize
    @white_king = BoardSquare.new(7, 4, King.new(true))
    @black_king = BoardSquare.new(0, 4, King.new(false))
    @board = [
      [BoardSquare.new(0, 0, Rook.new(false)), BoardSquare.new(0, 1, Knight.new(false)), BoardSquare.new(0, 2, Bishop.new(false)), BoardSquare.new(0, 3, Queen.new(false)), @black_king, BoardSquare.new(0, 5, Bishop.new(false)), BoardSquare.new(0, 6, Knight.new(false)), BoardSquare.new(0, 7, Rook.new(false))],
      [BoardSquare.new(1, 0, Pawn.new(false)), BoardSquare.new(1, 1, Pawn.new(false)), BoardSquare.new(1, 2, Pawn.new(false)), BoardSquare.new(1, 3, Pawn.new(false)), BoardSquare.new(1, 4, Pawn.new(false)), BoardSquare.new(1, 5, Pawn.new(false)), BoardSquare.new(1, 6, Pawn.new(false)), BoardSquare.new(1, 7, Pawn.new(false))],
      [BoardSquare.new(2, 0, nil), BoardSquare.new(2, 1, nil), BoardSquare.new(2, 2, nil), BoardSquare.new(2, 3, nil), BoardSquare.new(2, 4, nil), BoardSquare.new(2, 5, nil), BoardSquare.new(2, 6, nil), BoardSquare.new(2, 7, nil)],
      [BoardSquare.new(3, 0, nil), BoardSquare.new(3, 1, nil), BoardSquare.new(3, 2, nil), BoardSquare.new(3, 3, nil), BoardSquare.new(3, 4, nil), BoardSquare.new(3, 5, nil), BoardSquare.new(3, 6, nil), BoardSquare.new(3, 7, nil)],
      [BoardSquare.new(4, 0, nil), BoardSquare.new(4, 1, nil), BoardSquare.new(4, 2, nil), BoardSquare.new(4, 3, nil), BoardSquare.new(4, 4, nil), BoardSquare.new(4, 5, nil), BoardSquare.new(4, 6, nil), BoardSquare.new(4, 7, nil)],
      [BoardSquare.new(5, 0, nil), BoardSquare.new(5, 1, nil), BoardSquare.new(5, 2, nil), BoardSquare.new(5, 3, nil), BoardSquare.new(5, 4, nil), BoardSquare.new(5, 5, nil), BoardSquare.new(5, 6, nil), BoardSquare.new(5, 7, nil)],
      [BoardSquare.new(6, 0, Pawn.new(true)), BoardSquare.new(6, 1, Pawn.new(true)), BoardSquare.new(6, 2, Pawn.new(true)), BoardSquare.new(6, 3, Pawn.new(true)), BoardSquare.new(6, 4, Pawn.new(true)), BoardSquare.new(6, 5, Pawn.new(true)), BoardSquare.new(6, 6, Pawn.new(true)), BoardSquare.new(6, 7, Pawn.new(true))],
      [BoardSquare.new(7, 0, Rook.new(true)), BoardSquare.new(7, 1, Knight.new(true)), BoardSquare.new(7, 2, Bishop.new(true)), BoardSquare.new(7, 3, Queen.new(true)), @white_king, BoardSquare.new(7, 5, Bishop.new(true)), BoardSquare.new(7, 6, Knight.new(true)), BoardSquare.new(7, 7, Rook.new(true))]
    ]
  end
end

class BoardSquare
  attr_accessor :x, :y, :piece
  def initialize(y, x, piece)
    @x = x
    @y = y
    @piece = piece
  end
end