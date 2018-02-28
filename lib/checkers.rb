
# extra - make code more effecient, i.e. passing jumpable arg twice, tile doesn't need to be called as an instance only position really important (check), jumped_position arg not needed, cases instead of if/else


require 'ruby2d'
require_relative 'checkers/piece'
require_relative 'checkers/board'
require_relative 'checkers/tile'
require_relative 'checkers/robot_text'

#set up board
set width: 1000
set height: 900


board = Board.new()


#play
update do
	if board.active_white_pieces.empty?
		board.erase_board("black")
		board.endgame_message("black")
	elsif board.active_black_pieces.empty?
		board.erase_board("white")
		board.endgame_message("white")
	else
		piece = Piece.clicked_piece
		tile = Tile.clicked_tile
		if piece != nil && tile != nil
			pos1 = piece.position
			pos2 = tile.position
			if piece.team == board.turn
				y_delta = tile.y_pos - piece.y_pos
				abs_x_delta = (tile.x_pos - piece.x_pos).abs
				moveable_white = piece.team == :white || piece.queen
				moveable_black = piece.team == :black || piece.queen
				if y_delta == 1 && abs_x_delta == 1 && moveable_white
					board.move(piece, pos2)
				elsif y_delta == -1 && abs_x_delta == 1 && moveable_black
					board.move(piece, pos2)
				else
					jumpable = board.jumpable(pos1, pos2)
					if jumpable
						if y_delta == 2 && abs_x_delta == 2 && moveable_white 
							board.jump(piece, pos2, jumpable[:jumped_piece], jumpable[:jumped_position])
						elsif y_delta == -2 && abs_x_delta == 2 && moveable_black 
							board.jump(piece, pos2, jumpable[:jumped_piece], jumpable[:jumped_position])
						end
					end
					
					double_jumpable = board.double_jumpable(pos1, pos2)
					if double_jumpable
						if y_delta == 4 && abs_x_delta == 4 || 0 && moveable_white 
							board.double_jump(double_jumpable)
						elsif y_delta == -4 && abs_x_delta == 4 || 0 && moveable_black 
							board.double_jump(double_jumpable)
						else
							board.change_prompt("Can't make that move bitch!")
						end
					end
				end
			else
				board.change_prompt("Ain't yo turn!")
			end
			Tile.reset_clicked_tile
			Piece.reset_clicked_piece
		end
	end
end

show








