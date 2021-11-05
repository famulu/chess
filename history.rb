class ChessTurn
  attr_accessor :initial, :final, :initial_coord, :en_passant, :castling, :promotion, :chosen_piece
  
  def initialize(initial, final)
    @initial = initial
    @initial_coord = {:x => initial.x, :y => initial.y}
    @final = final
  end
end

class ChessHistory
  attr_accessor :turns, :pointer

  def initialize
    @turns = []
    @pointer = -1 # No turns played yet
  end
end

def undo_turn(history, board)
  if history.pointer >= 0
    turn = history.turns[history.pointer]
    initial = turn.initial
    final = turn.final
    initial_coord = turn.initial_coord

    move_square(initial, initial_coord[:x], initial_coord[:y], final, board)
    if turn.en_passant
      killed_pawn_y = initial_coord[:y]
      killed_pawn_x = final.x
      @en_passant = BoardSquare.new(killed_pawn_y, killed_pawn_x, Pawn.new(!initial.piece.is_white))
      board[killed_pawn_y][killed_pawn_x] = @en_passant
    elsif turn.castling
      castled_rook_old_x = final.x + (final.x < initial_coord[:x] ? 1 : -1)
      castled_rook_new_x = final.x < initial_coord[:x] ? 0 : 7
      castled_rook = @board[final.y][castled_rook_old_x]
      move_square(castled_rook, castled_rook_new_x, final.y, BoardSquare.new(final.y, castled_rook_old_x, nil), board) 
      castled_rook.piece.has_moved = false
      initial.piece.has_moved = false
    end

    if history.pointer >= 1
      prev_turn = history.turns[history.pointer - 1]
      moved_square = prev_turn.initial
      replaced_square = prev_turn.final
      moved_square_coord = prev_turn.initial_coord
      if Pawn === moved_square.piece
        if (replaced_square.y - moved_square_coord[:y]).abs == 2
          @en_passant = moved_square
        end
      end
    end
    history.pointer -= 1
    return true
  end

  return false
end

def redo_turn(history, board)
  if history.pointer < history.turns.length - 1
    history.pointer += 1
    turn = history.turns[history.pointer]
    initial = turn.initial
    final = turn.final
    
    move_square(initial, final.x, final.y, BoardSquare.new(initial.y, initial.x, nil), board)
    
    if turn.en_passant
      board[@en_passant.y][@en_passant.x] = BoardSquare.new(@en_passant.y, @en_passant.x, nil)
      @en_passant = nil
    elsif turn.castling
      castled_rook_new_x = final.x + (final.x == 2 ? 1 : -1)
      castled_rook_old_x = final.x == 2 ? 0 : 7
      p final
      p initial
      castled_rook = @board[final.y][castled_rook_old_x]
      move_square(castled_rook, castled_rook_new_x, final.y, BoardSquare.new(final.y, castled_rook_old_x, nil), board) 
      castled_rook.piece.has_moved = true
      initial.piece.has_moved = true
    elsif turn.promotion
      board[initial.y][initial.x] = turn.chosen_piece
    end
    return true
  end
  
  return false
end

def add_to_history(history, initial, final)
  history.pointer += 1
  history.turns[history.pointer] = ChessTurn.new(initial, final)
end

def pop_from_history(history)
  history.turns.pop()
  history.pointer -= 1
end
