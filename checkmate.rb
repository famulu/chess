def is_checkmated?(king, board, attacker)
  
  puts "Inside is_checkmated?()"
  
  if defenders = is_checked?(attacker, board, true)
    defenders.each do |defender|
      if move_square_okay?(defender, attacker, board, king)
        puts "Attacker can be captured"
        return false
      end
    end
  end

  if can_evade?(king, board, attacker)
    puts "Attack can be evaded"
    return false
  end

  if can_block?(king, board, attacker)
    puts "Attack can be blocked"
    return false
  end

  puts "Checkmate!"
  return true
  
end

def can_evade?(king, board, attacker)

  configurations = [
    {x_step: -1, y_step: -1},
    {x_step: -1, y_step: 0},
    {x_step: -1, y_step: 1},
    {x_step: 0, y_step: -1},
    {x_step: 0, y_step: 1},
    {x_step: 1, y_step: -1},
    {x_step: 1, y_step: 0},
    {x_step: 1, y_step: 1}
  ]

  configurations.each do |config|
    y = king.y + config[:y_step]
    if y.between?(0, 7) && board[y] != nil
      x = king.x + config[:x_step]
      checking = board[y][x]
      if x.between?(0, 7) && checking != nil
        if checking.piece == nil || checking.piece.is_white != king.piece.is_white
          if move_square_okay?(king, checking, board, king)
            return true
          end
        end
      end
    end
  end

  puts "can_evade?() is false"
  return false

end

def can_block?(king, board, attacker)

  puts "Inside can_block?()"

  if Rook === attacker.piece || Queen === attacker.piece
    puts "Checking if Rook-ish pieces can be blocked"
    if can_block_rook_or_queen?(king, board, attacker)
      return true
    end
    puts "Rook-ish piece could not be blocked"
  end

  if Bishop === attacker.piece || Queen === attacker.piece
    puts "Checking if Bishop-ish pieces can be blocked"
    if can_block_bishop_or_queen?(king, board, attacker)
      return true
    end
    puts "Bishop-ish piece could not be blocked"
  end

  puts "Attack cannot be blocked"
  return false

end

def block_okay?(king, board, start_x, start_y, end_x, end_y, x_step, y_step)

  while start_x != end_x && start_y != end_y
    start_x += x_step
    start_y += y_step

    if defenders = is_checked?(BoardSquare.new(start_y, start_x, King.new(!king.piece.is_white)), board, true)
      defenders.each do |defender|

        empty_square = board[start_y][start_x]

        if Pawn === defender.piece
          if pawn = blocked_by_pawn?(start_x, start_y, king.piece.is_white, board)
            if move_square_okay?(pawn, empty_square, board, king)
              return true
            end
          end
        else
          if move_square_okay?(defender, empty_square, board, king)
            return true
          end
        end

      end
    end

  end

  return false

end

def can_block_rook_or_queen?(king, board, attacker)

  if king.x == attacker.x
    x = king.x
    min = [king.y, attacker.y].min
    max = [king.y, attacker.y].max

    return block_okay?(king, board, x, min, x + 1, max, 0, 1)

  elsif king.y == attacker.y
    y = king.y
    min = [king.x, attacker.x].min
    max = [king.x, attacker.x].max

    return block_okay?(king, board, min, y, max, y + 1, 1, 0)

  end

  return false

end

def can_block_bishop_or_queen?(king, board, attacker)

  if (attacker.y - king.y) == (attacker.x - king.x)
    start = king.x < attacker.x ? king : attacker
    range = (attacker.x - king.x).abs

    return block_okay?(king, board, start.x, start.y, start.x + range, start.y + range, 1, 1)

  elsif (attacker.y - king.y) == -1 * (attacker.x - king.x)
    start = king.x < attacker.x ? king : attacker
    range = (attacker.x - king.x).abs

    return block_okay?(king, board, start.x, start.y, start.x + range, start.y + range, 1, -1)

  end

  return false

end

def blocked_by_pawn?(x, y, is_white, board)

  pawn_y = y - (is_white ? 1 : -1)
  if pawn_y.between?(0, 7) && Pawn === board[pawn_y][x].piece && board[pawn_y][x].piece.is_white == is_white
    return board[pawn_y][x]
  end

  pawn_y = y - (is_white ? 2 : -2)
  if pawn_y.between?(0, 7) && Pawn === board[pawn_y][x].piece && board[pawn_y][x].piece.is_white == is_white
    return board[pawn_y][x]
  end

  return false

end
