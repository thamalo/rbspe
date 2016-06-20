$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rbspe'

def input_512x512
	dimx = 512
	dimy = 512
	input1 = Array.new(dimx * dimy){0}
	input = []
	input1.each_with_index do |x, i|
		if i.odd? 
			x = 100
		else 
			x = 200
		end
		input << x
	end
	input
end
