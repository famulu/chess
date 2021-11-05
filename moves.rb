def valid_move?(initial, final, board, en_passant)
  case initial.piece
  when King
    return valid_king_move?(initial, final, board)
  when Queen
    return valid_bishop_move?(initial, final, board) || valid_rook_move?(initial, final, board)
  when Bishop
    return valid_bishop_move?(initial, final, board)
  when Knight
    return valid_knight_move?(initial, final)
  when Rook
    return valid_rook_move?(initial, final, board)
  when Pawn
    return valid_pawn_move?(initial, final, en_passant, board)
  else
    puts "What the hell is happening over here!"
    puts initial.piece.class
  end
end

def valid_king_move?(initial, final, board)
  if (final.x - initial.x).abs <= 1 && (final.y - initial.y).abs <= 1
    return true
  elsif (final.y == initial.y) && (final.x - initial.x).abs == 2
    if !initial.piece.has_moved
      if !is_checked?(initial, board, false)
        middle_piece_x = (initial.x + final.x) / 2
        if board[initial.y][middle_piece_x].piece == nil
          if !is_checked?(BoardSquare.new(initial.y, middle_piece_x, King.new(initial.piece.is_white)), board, false)
            castled_rook_x = final.x < initial.x ? 0 : 7
            castled_rook = board[initial.y][castled_rook_x]
            if castled_rook.piece != nil
              if Rook === castled_rook.piece && !castled_rook.piece.has_moved
                if final.x > initial.x || board[initial.y][1].piece == nil
                  return true
                end
              end
            end
          end
        end
      end
    end
  end
  return false
end

def valid_rook_move?(initial, final, board)
  if initial.x == final.x
    min = [initial.y, final.y].min + 1
    max = [initial.y, final.y].max

    (min...max).each do |j|
      if board[j][initial.x].piece != nil
        return false
      end
    end

    return true
  elsif initial.y == final.y
    min = [initial.x, final.x].min + 1
    max = [initial.x, final.x].max

    (min...max).each do |i|
      if board[initial.y][i].piece != nil
        return false
      end
    end

    return true
  end

  return false
end

def valid_bishop_move?(initial, final, board)
  if (final.y - initial.y) == (final.x - initial.x)
    start = initial.x < final.x ? initial : final
    i = 1
    range = (final.x - initial.x).abs
    while i < range
      if board[start.y + i][start.x + i].piece != nil
        return false
      end
      i += 1
    end
    return true
  elsif (final.y - initial.y) == -1 * (final.x - initial.x)
    start = initial.x < final.x ? initial : final
    i = 1
    range = (final.x - initial.x).abs
    while i < range
      if board[start.y - i][start.x + i].piece != nil
        return false
      end
      i += 1
    end
    return true
  else
    return false
  end
end

def valid_knight_move?(initial, final)
  if (final.y - initial.y).abs * (final.x - initial.x).abs == 2
    return true
  end
  return false
end


def valid_pawn_move?(initial, final, en_passant, board)
  if (final.y - initial.y) == (-1 * (initial.piece.is_white ? 1 : -1))
    if (final.x - initial.x).abs == (final.piece != nil ? 1 : 0)
      return true
    elsif @en_passant != nil
      if (final.x == @en_passant.x) && (final.y == @en_passant.y + (@en_passant.piece.is_white ? 1 : -1))
        return true
      end
    end
  elsif (final.y - initial.y) == (-2 * (initial.piece.is_white ? 1 : -1))
    if initial.y == 3.5 + 2.5 * (initial.piece.is_white ? 1 : -1) && initial.x == final.x
      if final.piece == nil && board[initial.y + (initial.piece.is_white ? -1 : 1)][initial.x].piece == nil
        return true
      end
    end
  end
  return false
end
