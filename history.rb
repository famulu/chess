class ChessTurn
  attr_accessor :initial, :final, :initial_coord
  
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
    initial = history.turns[history.pointer].initial
    final = history.turns[history.pointer].final
    initial_coord = history.turns[history.pointer].initial_coord
    
    move_square(initial, initial_coord[:x], initial_coord[:y], final, board)
    history.pointer -= 1
    return true
  end

  return false
end

def redo_turn(history, board)
  if history.pointer < history.turns.length - 1
    history.pointer += 1
    initial = history.turns[history.pointer].initial
    final = history.turns[history.pointer].final
    
    move_square(initial, final.x, final.y, BoardSquare.new(initial.y, initial.x, nil), board)
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
