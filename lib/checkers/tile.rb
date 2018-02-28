require 'ruby2d'
require_relative 'board'
require_relative 'piece'

class Tile < Square
	@@clicked_tile = nil
	@@playable_tiles = []
	attr_reader :x_pos, :y_pos
	def initialize(opts = {})
		extend Ruby2D::DSL
		@x_pos = opts[:x_pos]
		@y_pos = opts[:y_pos]
		
		@x = opts[:x] || opts[:x_pos]*90 + 50 || 0
	    @y = opts[:y] || opts[:y_pos]*90 - 50 || 0
	    @z = opts[:z] || 0
	    @width = @height = @size = opts[:size] || 90

	    self.color = opts[:color] || 'white'

	    update_coords(@x, @y, @size, @size)

	    add

		@click_event = on :mouse_down do |e|
	    	if self.contains?(e.x, e.y) && @@playable_tiles.include?([opts[:x_pos], opts[:y_pos]]) && Piece.clicked_piece != nil
	    		@@clicked_tile = self
	    	end
	    end
	end
	def self.clicked_tile
		@@clicked_tile
	end
	def self.reset_clicked_tile
		@@clicked_tile = nil
	end
	
	def self.playable_tiles
		@@playable_tiles
	end
	def self.add_playable_tile(piece_pos)
		@@playable_tiles.push(piece_pos)
	end
	def self.delete_playable_tile(tile_pos)
		@@playable_tiles.delete(tile_pos)
	end
	def self.tile_by_position(position)
		@@playable_tiles.select{|tile| tile.position==position}[0]
	end
	def position
		[@x_pos, @y_pos]
	end
end