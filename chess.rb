require "gosu"
require_relative "pieces"
require_relative "board"
require_relative "moves"
require_relative "check"
require_relative "move_square"
require_relative "checkmate"
require_relative "history"

COLORS = [Gosu::Color.new(0xFF1EB1FA), Gosu::Color.new(0xFF1D4DB5)]

module ZOrder
  BACKGROUND, UI, OVERLAY, OVERLAY_BACKGROUND, OVERLAY_UI = *0..4
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
    @history = ChessHistory.new

    @promoted_piece = nil
    @promotion_configurations = [
      {start_x: 30, end_x: 130, piece: Knight},
      {start_x: 190, end_x: 290, piece: Queen},
      {start_x: 350, end_x: 450, piece: Bishop},
      {start_x: 510, end_x: 610, piece: Rook}
    ]
  end
  
  def promote_pawn(y, x)

    if y.between?(270, 370)
      @promotion_configurations.each do |config|
        if x.between?(config[:start_x], config[:end_x])
          new_piece = BoardSquare.new(@promoted_piece.y, @promoted_piece.x, config[:piece].new(@promoted_piece.piece.is_white))
          @history.turns[@history.pointer].chosen_piece = new_piece
          @board[@promoted_piece.y][@promoted_piece.x] = new_piece
          @promoted_piece = nil
          return
        end
      end
    end

  end

  def button_down(id)
    if id == Gosu::MsLeft
      if @promoted_piece
        promote_pawn(mouse_y(), mouse_x())
      else
        if mouse_y() <= 630 && mouse_y() >= 530
          if mouse_x() >= 650 && mouse_x() <= 730
            if undo_turn(@history, @board)
              @white_turn = !@white_turn
            end
          elsif mouse_x() >= 750 && mouse_x() <= 830
            if redo_turn(@history, @board)
              @white_turn = !@white_turn
            end
          end
        end
  
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
  
                    add_to_history(@history, @selected, target_piece)
                    move_square(@selected, x, y, BoardSquare.new(@selected.y, @selected.x, nil), @board)
                    if is_checked?((@white_turn ? @white_king : @black_king), @board, false)
                      move_square(@selected, selected_coord[:x], selected_coord[:y], target_piece, @board)
                      pop_from_history(@history)
                    else
                      if Pawn === @selected.piece
                        if (selected_coord[:y] - y).abs == 2
                          @en_passant = @selected
                        elsif @en_passant != nil
                          if (@selected.x == @en_passant.x) && (@selected.y == @en_passant.y + (@en_passant.piece.is_white ? 1 : -1))
                            @board[@en_passant.y][@en_passant.x] = BoardSquare.new(@en_passant.y, @en_passant.x, nil)
                            @history.turns[@history.pointer].en_passant = true
                          end
                          @en_passant = nil
                        end
  
                        if y == (@selected.piece.is_white ? 0 : 7)
                          @promoted_piece = @selected
                          @history.turns[@history.pointer].promotion = true
                        end
                      elsif King === @selected.piece
                        if (selected_coord[:x] - x).abs == 2
                          # King has castled
                          castled_rook_new_x = x + (x < selected_coord[:x] ? 1 : -1)
                          castled_rook_old_x = x < selected_coord[:x] ? 0 : 7
                          castled_rook = @board[y][castled_rook_old_x]
                          move_square(castled_rook, castled_rook_new_x, y, BoardSquare.new(y, castled_rook_old_x, nil), @board) 
                          @history.turns[@history.pointer].castling = true
                          castled_rook.piece.has_moved = true
                        end
                        @selected.piece.has_moved = true
                      elsif Rook === @selected.piece
                        @selected.piece.has_moved = true
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

    Gosu.draw_rect(650, 530, 80, 100, COLORS[0], ZOrder::UI)
    @text_font.draw_text_rel("Undo", 690, 580, ZOrder::UI, 0.5, 0.5)

    Gosu.draw_rect(750, 530, 80, 100, COLORS[0], ZOrder::UI)
    @text_font.draw_text_rel("Redo", 790, 580, ZOrder::UI, 0.5, 0.5)

    if @selected != nil
      @text_font.draw_text("Column: #{@selected.x}\nRow: #{@selected.y}", 650, 300, ZOrder::UI)
      @text_font.draw_text("#{@selected.piece.is_white ? "White" : "Black"} #{@selected.piece.class.to_s}", 650, 360, ZOrder::UI)
      Gosu.draw_rect(@selected.x * SQUARE_LENGTH, @selected.y * SQUARE_LENGTH, BORDER_WIDTH, SQUARE_LENGTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
      Gosu.draw_rect((@selected.x + 1) * SQUARE_LENGTH - BORDER_WIDTH, @selected.y * SQUARE_LENGTH, BORDER_WIDTH, SQUARE_LENGTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
      Gosu.draw_rect(@selected.x * SQUARE_LENGTH, @selected.y * SQUARE_LENGTH, SQUARE_LENGTH, BORDER_WIDTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
      Gosu.draw_rect(@selected.x * SQUARE_LENGTH, (@selected.y + 1) * SQUARE_LENGTH - BORDER_WIDTH, SQUARE_LENGTH, BORDER_WIDTH, Gosu::Color::BLACK, ZOrder::OVERLAY)
    end

    if @promoted_piece
      promotion_color = COLORS[(@white_turn ? 1 : 0)]
      Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color.argb(0xAF_000000), ZOrder::OVERLAY)

      Gosu.draw_rect(30, 270, 100, 100, promotion_color, ZOrder::OVERLAY_BACKGROUND)
      @font.draw_text_rel(Knight.new(!@white_turn).symbol, 80, 320, ZOrder::OVERLAY_UI, 0.5, 0.5)
      Gosu.draw_rect(190, 270, 100, 100, promotion_color, ZOrder::OVERLAY_BACKGROUND)
      @font.draw_text_rel(Queen.new(!@white_turn).symbol, 240, 320, ZOrder::OVERLAY_UI, 0.5, 0.5)
      Gosu.draw_rect(350, 270, 100, 100, promotion_color, ZOrder::OVERLAY_BACKGROUND)
      @font.draw_text_rel(Bishop.new(!@white_turn).symbol, 400, 320, ZOrder::OVERLAY_UI, 0.5, 0.5)
      Gosu.draw_rect(510, 270, 100, 100, promotion_color, ZOrder::OVERLAY_BACKGROUND)
      @font.draw_text_rel(Rook.new(!@white_turn).symbol, 560, 320, ZOrder::OVERLAY_UI, 0.5, 0.5)
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