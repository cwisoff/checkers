#file path for robot font
require 'ruby2d'
# For debugging. Wouldn't normally be left in the commit. 
# require 'byebug'

class RobotText < Text
  # in most cases extending/including happens at the top of the class.
  extend Ruby2D::DSL

  # Delete if using the line by line
  DEFAULT_OPTS = {
    x: 400, 
    y: 5,
    z: 0,
    text: "Hello World!",
    size: 25,
    font: "../checkers/data/Roboto-Regular.ttf" # '..' means the directory above this one.
  }.freeze

	def initialize(opts = {})
    # This would also work in lieu of the DEFAULT_OPTS hash. I prefer
    # using the constant because it clearly separates out the 'settings'
    # from the logic. Both are reasonable though.
		# opts[:x] || opts[:x] = 400
  #   opts[:y] || opts[:y] = 5
  #   opts[:z] || opts[:z] = 0
  #   opts[:text] || opts[:text] = "Hello World!"
  #   opts[:size] || opts[:size] = 25
  #   opts[:font] || opts[:font] = "../checkers/data/Roboto-Regular.ttf"

    # Delete this if using the commented out code above.
    DEFAULT_OPTS.each do |k,v|
      opts[k] || opts[k] = v
    end

    # How I debugged. This 'byebug' pauses execution here, then in the console
    # you can type 'opts' to verify that your defaults have been added and your
    # custom inputs remain. I also put a byebug at the start of the parent's
    # initialize method in the gem source code to verify that the opts hash was
    # passed to #super. That's how you would debug #super's behavior if you weren't
    # sure.
    # byebug

    # super is special in that parenthesis matter. Without parenthesis it will
    # call the parent's #initialize with the same arguments given to this 
    # method (or in our case, the modified opts hash). Calling 'super()' sends 
    # no arguments. Or you can do "super(fuck_yall: 'Ima send this instead')"
    super
	end

	def change_text(text)
		remove
		@text = text.to_s
		ext_init
		add
	end
end