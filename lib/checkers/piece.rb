require 'ruby2d'
require_relative 'robot_text.rb'

#checker pieces

class Piece < Square
	@@active_pieces = []
	@@clicked_piece = nil
	attr_reader :team
	attr_accessor :x_pos, :y_pos, :queen, :color_change
	def initialize(opts = {})
		extend Ruby2D::DSL
		@x_pos = opts[:x_pos]
		@y_pos = opts[:y_pos]
		@team = opts[:team]
		@queen = false
		@@active_pieces.push(self)
		
		@x = opts[:x] || opts[:x_pos]*90 + 65 || 0
	    @y = opts[:y] || opts[:y_pos]*90 - 35 || 0
	    @z = opts[:z] || 1
	    @width = @height = @size = opts[:size] || 60

	    @color_change = nil
	    self.color = opts[:color] || 'white'

	    update_coords(@x, @y, @size, @size)

	    add

	    @click_event = on :mouse_down do |e|
	    	if self.contains?(e.x, e.y) && @@active_pieces.include?(self)
	    		@@clicked_piece = self
	    		if queen
	    			self.color = opts[:color]
	    		else
	    			self.color = "gray"
	    		end
	    	else
	    		self.color = @color_change || opts[:color] || 'white'
	    	end
	    end
	end

	def self.clicked_piece
		@@clicked_piece
	end
	def self.reset_clicked_piece
		@@clicked_piece = nil
	end
	def self.active_pieces
		@@active_pieces
	end
	def self.remove_active_piece(piece)
		piece.remove
		@@active_pieces.delete(piece)
	end
	def self.piece_by_position(position)
		@@active_pieces.select{|piece| piece.position==position}[0]
	end

	def position
		[@x_pos, @y_pos]
	end
	
	def move(new_position)
		remove
		@x_pos = new_position[0]
		@y_pos = new_position[1]
		@x = @x_pos*90 + 65 
	    @y = @y_pos*90 - 35 
	    update_coords(@x, @y, @width, @height)

	    if @team == :white && @y_pos == 8
			queen_me
		elsif @team == :black && @y_pos == 1
			queen_me
		end

	    add 
	end

	def queen_me
		@queen = true
		self.color = "yellow"
		@color_change = "yellow"
		
	end
end