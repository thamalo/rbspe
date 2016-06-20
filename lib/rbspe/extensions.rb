class Array
	def mean
		reduce(&:+) / size.to_f
	end
end