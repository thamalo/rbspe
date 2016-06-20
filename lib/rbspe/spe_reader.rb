require_relative 'image_reader'
require_relative 'header'

module Rbspe
    class SpeReader < ImageReader
        include FRead
        
        attr_reader :header
    	def self.can_read?(path)
    		/.*\.spe/ =~ path || /.*\.SPE/ =~ path
    	end

    	def initialize(path, num = 0)
    		@path = path
    		@num = num
    		
    	end 

    	def read(path, num)
    		get_file_attributes(path)
    		check_frame_number num
    		data = read_image(path, num)
    		Image.new(@header.xdim, @header.ydim, data)
    	end

        def get_file_attributes(file)
            @header = Header.new(file)
        end


        def check_frame_number(num)
            if (num < 0) || (num > (@header.numFrames - 1))
                raise ArgumentError, "
                    Impossible de lire l'image numero #{num}. 
                    Le numero d'image doit être compris entre 0 
                    et #{@header.numFrames - 1} le nombre d'image dans le fichier 
                   "
            end
        end

        def read_image(file, num)
            get_data(file, num)
        end

        def get_data(file, num)
            data = []
            dim = @header.xdim * @header.ydim
            each_data_size = DATATYPE[@header.datatype][0]
            directive = DATATYPE[@header.datatype][1]
            offset = 4100 + each_data_size * dim * num
            
            open file, 'rb' do |f|
                data = read_data(f, dim*SIZE, offset, directive * dim)
            end

            data
        end

    end
end

