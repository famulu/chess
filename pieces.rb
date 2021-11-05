class King
  attr_accessor :symbol, :is_white, :has_moved
  def initialize(is_white)
    @is_white = is_white
    @symbol = is_white ? "\u2654" : "\u265A"
    @has_moved = false
  end
end

class Queen
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    @symbol = is_white ? "\u2655" : "\u265B"
  end
end

class Bishop
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    @symbol = is_white ? "\u2657" : "\u265D"
  end
end

class Knight
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    @symbol = is_white ? "\u2658" : "\u265E"
  end
end

class Rook
  attr_accessor :symbol, :is_white, :has_moved
  def initialize(is_white)
    @is_white = is_white
    @has_moved = false
    @symbol = is_white ? "\u2656" : "\u265C"
  end
end

class Pawn
  attr_accessor :symbol, :is_white
  def initialize(is_white)
    @is_white = is_white
    @symbol = is_white ? "\u2659" : "\u265F"   
  end
end
