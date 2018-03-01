# I didn't integrate this into the program, but this is an simplified example of
# what refactoring your '@@active_pieces' class variable in Piece might look like.
# Piece becomes responsible only for a single piece -- it doesn't know 
# anything about the other pieces. Board would create and hold onto a(the) 
# instance of Pieces. Pieces manages the collection of pieces (adding, deleting,
# finding the piece at the position, setting active piece, etc). This also
# applies to Tile vs Tiles. 
# 
# Then you might do something on a click event like:
# if piece = @pieces.piece_by_position(clicked_tile.position)
#   @pieces.clicked_piece = piece
#   # waiting for a move workflow
# else
#   # there's no piece there, stupid
# end

class Pieces
  attr_accessor :active_pieces, :clicked_piece

  def initialize
    @active_pieces = []
  end

  def remove_piece(piece)
    active_pieces.delete(piece)
  end

  def add_piece(piece)
    active_pieces << piece
  end

  def piece_by_position(position)
    active_pieces.find { |piece| piece.position == position }
  end

  # @clicked_piece could also live in Board.
  def reset_clicked_piece
    self.clicked_piece = nil
  end
end
