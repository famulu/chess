def move_square(piece_square, new_x, new_y, undone_square, board)

  board[piece_square.y][piece_square.x] = undone_square
  piece_square.x, piece_square.y = new_x, new_y
  board[new_y][new_x] = piece_square

end

def move_square_okay?(initial_square, final_square, board, king)

  initial_coord = {x: initial_square.x, y: initial_square.y}
  move_square(initial_square, final_square.x, final_square.y, BoardSquare.new(initial_square.y, initial_square.x, nil), board)
  dud_move = is_checked?(king, board, false)
  move_square(initial_square, initial_coord[:x], initial_coord[:y], final_square, board)

  return !dud_move

end