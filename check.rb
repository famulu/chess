def is_checked?(king, board, all)

  all_attackers = []

  if attacker = checked_by_rook_or_queen?(king, board, all)
    p "checked by rook/queen"
    if all
      all_attackers += attacker
    else
      return attacker
    end
  end

  if attacker = checked_by_bishop_or_queen?(king, board, all)
    p "checked by bishop/queen"
    if all
      all_attackers += attacker
    else
      return attacker
    end
  end

  if attacker = checked_by_knight?(king, board, all)
    p "checked by knight"
    if all
      all_attackers += attacker
    else
      return attacker
    end
  end

  if attacker = checked_by_pawn?(king, board, all)
    p "checked by pawn"
    if all
      all_attackers += attacker
    else
      return attacker
    end
  end

  if attacker = checked_by_king?(king, board)
    p "checked by king"
    if all
      all_attackers += [attacker]
    else
      return attacker
    end
  end

  if all_attackers.size > 0
    return all_attackers
  else
    return nil
  end

end

def checked_by_rook_or_queen?(king, board, all)

  configurations = [
    {x_step: 0, y_step: 1, x_limit: 8, y_limit: 8},
    {x_step: 0, y_step: -1, x_limit: 8, y_limit: -1},
    {x_step: 1, y_step: 0, x_limit: 8, y_limit: 8},
    {x_step: -1, y_step: 0, x_limit: -1, y_limit: 8}
  ]

  results = []

  configurations.each do |config|
    if result = found_pieces?(king.x, king.y, config[:x_step], config[:y_step], config[:x_limit], config[:y_limit], king.piece.is_white, [Rook, Queen], board)
      if all
        results.push(result)
      else
        return result
      end
    end
  end

  if results.size > 0
    return results
  else
    return false
  end
  
end

def found_pieces?(x, y, x_step, y_step, x_limit, y_limit, is_white, pieces, board)
  
  x += x_step
  y += y_step

  while x != x_limit && y != y_limit
    if board[y][x].piece != nil
      if board[y][x].piece.is_white != is_white && pieces.include?(board[y][x].piece.class)
        return board[y][x]
      end
      return false
    end

    x += x_step
    y += y_step
  end
  return false
end

def checked_by_bishop_or_queen?(king, board, all)

  configurations = [
    {x_step: 1, y_step: 1, x_limit: 8, y_limit: 8},
    {x_step: 1, y_step: -1, x_limit: 8, y_limit: -1},
    {x_step: -1, y_step: 1, x_limit: -1, y_limit: 8},
    {x_step: -1, y_step: -1, x_limit: -1, y_limit: -1}
  ]

  results = []

  configurations.each do |config|
    if result = found_pieces?(king.x, king.y, config[:x_step], config[:y_step], config[:x_limit], config[:y_limit], king.piece.is_white, [Bishop, Queen], board)
      if all
        results.push(result)
      else
        return result
      end
    end
  end

  if results.size > 0
    return results
  else
    return false
  end

end

def checked_by_knight?(king, board, all)

  configurations = [
    {x_step: 1, y_step: 2},
    {x_step: 1, y_step: -2},
    {x_step: -1, y_step: 2},
    {x_step: -1, y_step: -2},
    {x_step: 2, y_step: 1},
    {x_step: 2, y_step: -1},
    {x_step: -2, y_step: 1},
    {x_step: -2, y_step: -1}
  ]

  results = []

  configurations.each do |config|
    y = king.y + config[:y_step]
    if y.between?(0, 7) && board[y] != nil
      x = king.x + config[:x_step]
      checking = board[y][x]
      if x.between?(0, 7) && checking != nil
        if checking.piece != nil
          if checking.piece.is_white != king.piece.is_white && Knight === checking.piece
            if all
              results.push(checking)
            else
              return checking
            end
          end
        end
      end
    end
  end

  if results.size > 0
    return results
  else
    return false
  end

end

def checked_by_pawn?(king, board, all)

  configurations = [-1, 1]

  results = []

  configurations.each do |config|
    y = king.y + (king.piece.is_white ? -1 : 1)

    if y.between?(0, 7) && board[y] != nil
      x = king.x + config
      checking = board[y][x]
      if x.between?(0, 7) && checking != nil
        if checking.piece != nil && checking.piece.is_white != king.piece.is_white
          if Pawn === checking.piece
            if all
              results.push(checking)
            else
              return checking
            end
          end
        end
      end
    end
  end

  if results.size > 0
    return results
  else
    return false
  end

end

def checked_by_king?(king, board)

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
        if checking.piece != nil
          if checking.piece.is_white != king.piece.is_white && King === checking.piece
            return checking
          end
        end
      end
    end
  end

  return false

end