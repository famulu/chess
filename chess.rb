require "gosu"
require_relative "pieces"
require_relative "board"
require_relative "moves"
require_relative "check"
require_relative "move_square"
require_relative "checkmate"

COLORS = [Gosu::Color.new(0xFF1EB1FA), Gosu::Color.new(0xFF1D4DB5)]

module ZOrder
  BACKGROUND, UI, OVERLAY = *0..2
end

class ChessGameWindow < Gosu::Window
  WIDTH = 840
  HEIGHT = 640
  SQUARE_LENGTH = 80
  BORDER_WIDTH = 5

  def initialize
    super(WIDTH, HEIGHT)
    new_board = Board.new
    @board = new_board.board
    @white_king = new_board.white_king
    @black_king = new_board.black_king
    @font = Gosu::Font.new(90)
    @text_font = Gosu::Font.new(20)
    @selected = nil
    @white_turn = true
    @checked = false
    @checkmated = false
    @attacker = nil
    @en_passant = nil
  end
  
  def button_down(id)
    if id == Gosu::MsLeft
      @board.size.times do |y|
        @board[y].size.times do |x|
          if mouse_x() < (x + 1) * SQUARE_LENGTH && mouse_y() < (y + 1) * SQUARE_LENGTH
            if @selected == nil
              if @board[y][x].piece != nil && @white_turn == @board[y][x].piece.is_white
                @selected = @board[y][x]
              end
            else
              if (@board[y][x].piece == nil) || (@board[y][x].piece.is_white != @selected.piece.is_white)
                if valid_move?(@selected, @board[y][x], @board, @en_passant)
                  selected_coord = {x: @selected.x, y: @selected.y}
                  target_piece = @board[y][x]

                  move_square(@selected, x, y, nil, @board)
                  if is_checked?((@white_turn ? @white_king : @black_king), @board, false)
                    move_square(@selected, selected_coord[:x], selected_coord[:y], target_piece, @board)
                  else
                    if Pawn === @selected.piece
                      if (selected_coord[:y] - y).abs == 2
                        @en_passant = @selected
                      elsif @en_passant != nil
                        if (@selected.x == @en_passant.x) && (@selected.y == @en_passant.y + (@en_passant.piece.is_white ? 1 : -1))
                          @board[@en_passant.y][@en_passant.x] = BoardSquare.new(@en_passant.y, @en_passant.x, nil)
                        end
                        @en_passant = nil
                      end
                    end
                    @white_turn = !@white_turn                    
                  end

                end
              end
              @selected = nil
            end

            return
          end

        end
      end
    end
  end

  def update
    if @attacker = is_checked?((@white_turn ? @white_king : @black_king), @board, false)
      @checked = true
      @checkmated = is_checkmated?((@white_turn ? @white_king : @black_king), @board, @attacker)
    else
      @checked = false
    end
  end
  
  def draw
    @text_font.draw_text("x: #{mouse_x()}\ny: #{mouse_y()}", 650, 100, ZOrder::UI)
    
    @board.size.times do |y|
      @board[y].size.times do |x|
        Gosu.draw_rect(x * SQUARE_LENGTH, y * SQUARE_LENGTH, SQUARE_LENGTH, SQUARE_LENGTH, COLORS[(x + y) % 2], ZOrder::BACKGROUND)
        if @board[y][x].piece != nil
          @font.draw_text_rel(@board[y][x].piece.symbol, 40 + 80 * x, 40 + 80 * y, ZOrder::UI, 0.5, 0.5)
        end
      end
    end

    if @selected != nil
      @text_font.draw_text("Column: #{@selected.x}\nRow: #{@selected.y}", 650, 300, ZOrder::UI)
      @text_font.draw_text("#{@selected.piece.is_white ? "White" : "Black"} #{@selected.piece.class.to_s}", 650, 360, ZOrder::UI)
      Gosu.draw_rect(@selected.x * SQUARE_LENGTH, @selected.y * SQUARE_LENGTH, BORDER_WIDTH, SQUARE_LENGTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
      Gosu.draw_rect((@selected.x + 1) * SQUARE_LENGTH - BORDER_WIDTH, @selected.y * SQUARE_LENGTH, BORDER_WIDTH, SQUARE_LENGTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
      Gosu.draw_rect(@selected.x * SQUARE_LENGTH, @selected.y * SQUARE_LENGTH, SQUARE_LENGTH, BORDER_WIDTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
      Gosu.draw_rect(@selected.x * SQUARE_LENGTH, (@selected.y + 1) * SQUARE_LENGTH - BORDER_WIDTH, SQUARE_LENGTH, BORDER_WIDTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
    end

    if @checked
      if @checkmated
        @text_font.draw_text("#{(@white_turn ? "White" : "Black")} King Checkmated", 650, 420, ZOrder::UI)
      else
        @text_font.draw_text("#{(@white_turn ? "White" : "Black")} King Checked", 650, 390, ZOrder::UI)
      end
    end
  end
end

ChessGameWindow.new.show