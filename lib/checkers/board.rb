require 'ruby2d'
require_relative 'tile'
require_relative 'piece'
require_relative 'robot_text'

#latest iteration of the board

class Board
	attr_reader :turn
	attr_accessor :active_white_pieces, :active_black_pieces, :prompt
	def initialize
		@active_white_pieces = []
		@active_black_pieces = []
		@all_tiles = []
		@turn = :white
		
		for n in (1..8)
			if n % 2 == 0 
				for m in (1..8)
					if m % 2 == 0
						t = Tile.new(x_pos: n, y_pos: m, color: 'white')
						@all_tiles.push(t)
					else
						t = Tile.new(x_pos: n, y_pos: m, color: 'red')
						Tile.add_playable_tile([t.x_pos, t.y_pos])
						@all_tiles.push(t)
					end
				end
			else
				for m in (1..8)
					if m % 2 == 0
						t = Tile.new(x_pos: n, y_pos: m, color: 'red')
						Tile.add_playable_tile([t.x_pos, t.y_pos])
						@all_tiles.push(t)
					else
						t = Tile.new(x_pos: n, y_pos: m, color: 'white')
						@all_tiles.push(t)
					end
				end
			end
		end

		for x in (1..8)
			for y in (1..3)
				if (x % 2 == 0 && y % 2 != 0) || (x % 2 != 0 && y % 2 == 0)
					p = Piece.new(x_pos: x, y_pos: y, color: 'white', team: :white)
					@active_white_pieces.push(p)
					Tile.delete_playable_tile([p.x_pos, p.y_pos])
				end
			end
		end
		for x in (1..8)
			for y in (6..8)
				if (x % 2 == 0 && y % 2 != 0) || (x % 2 != 0 && y % 2 == 0)
					p = Piece.new(x_pos: x, y_pos: y, color: 'black', team: :black)
					@active_black_pieces.push(p)
					Tile.delete_playable_tile([p.x_pos, p.y_pos])
				end
			end
		end

		@prompt = RobotText.new(text: "White's Move!")
		
	end

	def change_prompt(text)
		@prompt.change_text(text)
	end

	def change_turn
		if @turn == :white
			@turn = :black
			@prompt.change_text("Black's Move!")
		elsif @turn == :black
			@turn = :white
			@prompt.change_text("Whites's Move!")
		end
	end

	def endgame_message(winning_team)
		@prompt.remove
		RobotText.new(text: "#{winning_team} Won!", y: 300, size: 50)
		RobotText.new(text: "Game Over", y: 400, size: 50)
	end

	def erase_board(winning_team)
		@all_tiles.each{|tile| tile.remove}
		if winning_team == "white"
			@active_white_pieces.each{|piece| piece.remove}
		elsif winning_team == "black"
			@active_black_pieces.each{|piece| piece.remove} 
		end
	end

	def move(piece, tile_position)
		Tile.add_playable_tile(piece.position)
		piece.move(tile_position)
		Tile.delete_playable_tile(tile_position)

		# Piece.reset_clicked_piece 
		# Tile.reset_clicked_tile 
		change_turn
	end

	def jumped_position (pos1, pos2)
		[(pos1[0] + pos2[0])/2, (pos1[1] + pos2[1])/2]
	end

	def jumpable(pos1, pos2)
		jumped_position = jumped_position(pos1, pos2)
		jumped_piece = Piece.piece_by_position(jumped_position)
		if jumped_piece && jumped_piece.team != Piece.clicked_piece.team
			{jumped_piece: jumped_piece, jumped_position: jumped_position}
		else
			false
		end
	end

	def jump(piece, tile_position, jumped_piece, jumped_position)
		Piece.remove_active_piece(jumped_piece)
		Tile.add_playable_tile(jumped_position)
		case jumped_piece.team
			when :white
				@active_white_pieces.delete(jumped_piece)
			when :black
				@active_black_pieces.delete(jumped_piece)
		end
		move(piece, tile_position)
	end

	def intermediate_positions(pos1, jump1_position, pos2)
		jumpables1 = jumpable(pos1, jump1_position)
		jumpables2 = jumpable(jump1_position, pos2)
		positions_hash = {
			pos1: pos1, 
			jump1_position: jump1_position, 
			pos2: pos2, 
			jumped_piece1: jumpables1[:jumped_piece],
			jumped_position1: jumpables1[:jumped_position],
			jumped_piece2: jumpables2[:jumped_piece],
			jumped_position2: jumpables2[:jumped_position]
		}
		return positions_hash
	end

	def double_jumpable(pos1, pos2)
		case 
			when (pos2[0] - pos1[0]).abs == 4 
				jump1_position = jumped_position(pos1, pos2)
				if jumpable(pos1, jump1_position) && jumpable(jump1_position, pos2)
					intermediate_positions(pos1, jump1_position, pos2)
				else
					false
				end
			when pos2[0] - pos1[0] == 0 
				fo_pos2 = [pos2[0] - 4, pos2[1]]
				jump1_position = jumped_position(pos1, fo_pos2)
				if jumpable(pos1, jump1_position) && jumpable(jump1_position, pos2)
					intermediate_positions(pos1, jump1_position, pos2)
				else
					fo_pos2 = [pos2[0] + 4, pos2[1]]
					jump1_position = jumped_position(pos1, fo_pos2)
					if jumpable(pos1, jump1_position) && jumpable(jump1_position, pos2)
						intermediate_positions(pos1, jump1_position, pos2)
					else
						false
					end
				end
		end
	end

	def double_jump(positions_hash)
		piece = Piece.piece_by_position(positions_hash[:pos1])
		jump(piece, positions_hash[:jump1_position], positions_hash[:jumped_piece1], positions_hash[:jumped_position1])
		jump(piece, positions_hash[:pos2], positions_hash[:jumped_piece2], positions_hash[:jumped_position2])
		change_turn
	end

end

