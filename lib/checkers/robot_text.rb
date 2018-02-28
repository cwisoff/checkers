#file path for robot font
require 'ruby2d'

class RobotText < Text
	def initialize(opts = {})
		extend Ruby2D::DSL
		 @x = opts[:x] || 400
      @y = opts[:y] || 5
      @z = opts[:z] || 0
      @text = (opts[:text] || "Hello World!").to_s
      @size = opts[:size] || 25

      @font = opts[:font] || "/Users/charlie/Documents/Ruby_Practice/checkers/data/Roboto-Regular.ttf"

      unless RUBY_ENGINE == 'opal'
        unless File.exists? @font
          raise Error, "Cannot find font file `#{@font}`"
        end
      end

      self.color = opts[:color] || 'white'
      ext_init
      add
	end
	def change_text(text)
		remove
		@text = text.to_s
		ext_init
		add
	end
end