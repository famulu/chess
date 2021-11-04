class King
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    @symbol = is_white ? "\u2654" : "\u265A"
  end
end

class Queen
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    if is_white
      @symbol = "\u2655"
    else
      @symbol = "\u265B"
    end
  end
end

class Bishop
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    if is_white
      @symbol = "\u2657"
    else
      @symbol = "\u265D"
    end
  end
end

class Knight
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    if is_white
      @symbol = "\u2658"
    else
      @symbol = "\u265E"
    end
  end
end

class Rook
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    if is_white
      @symbol = "\u2656"
    else
      @symbol = "\u265C"
    end
  end
end

class Pawn
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    if is_white
      @symbol = "\u2659"
    else
      @symbol = "\u265F"
    end
    
  end
end
