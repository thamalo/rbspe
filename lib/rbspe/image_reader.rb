
module Rbspe
	
	class ImageReader

		class << self
			attr_reader :reader_classes
		end

		@reader_classes = []

		def self.read(path, num = 0)
			reader = reader_for(path)
			return nil unless reader
			reader.read(path, num)
		end

		def self.reader_for(path)
			reader_class = ImageReader.reader_classes.find do |klass|
				klass.can_read?(path)
			end
			return reader_class.new(path) if reader_class
			nil 
		end

		def self.inherited(subclass)
			ImageReader.reader_classes << subclass
		end
	end
end
require_relative 'spe_reader'
# require other image readers here
# They should implement a can_read? and read methods
# see spe_reader for example
