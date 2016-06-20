require 'builder'
require_relative 'image_reader'
require_relative 'extensions'

# 
# Exception handling for statistics on empty image
# 
class EmptyImageException < Exception
end

# 
# Exception handling for out of bounds pixel positions
# 
class OutOfBoundsException < Exception
end

module Rbspe
    class Image  
       attr_reader :number_of_rows, :number_of_cols
       include Enumerable
       
       
        def initialize(row, col, data )
            @number_of_rows, @number_of_cols = row, col
            @data = data   
        end

        #
        #   retrieve the value at pixel (x,y)
        #   
        #   @return value
        def [](x,y)
            check_bounds(x,y)
            @data[x + y * @number_of_rows]
        end
        #
        # set value at pixel (x,y)
        # 
        def []=(x,y, value)
            check_bounds(x,y)
            @data[x + y * @number_of_rows ] = value 
        end
        
        #
        # The total number of pixels 
        #  
        #  @return @data.size
        #
        def size
            @data.size
        end

        def each
            @data.each { |data| yield data }
        end
        # 
        # Process the mean of pixel values
        # 
        # @return mean
        # 
        def mean
            verify_not_empty 
            sum / size.to_f
        end
        # 
        # Process the median of pixel values
        # 
        # @return median
        # 
        def median
            verify_not_empty
            middle = size / 2 
            median = sort_data[middle]
            return median.to_f if size.odd?
            0.5 * (sort_data[middle - 1] + median)
        end
        # 
        # Process the sum of pixel values
        # 
        # @return sum
        # 
        def sum
            verify_not_empty
            @data.reduce(&:+) # reduce == inject
        end

        # 
        # Process the std of pixel values
        # 
        # @return std
        # 
        def standard_deviation
            sqrt(variance)
        end 

        # 
        # Process the variance of pixel values
        # 
        # @return variance
        # 
        def variance
            rms_data.mean
        end

        # 
        # Process the rms of pixel values
        # 
        # @return rms_data
        # 
        def rms_data
            var = []
            a_mean = mean
            @data.each { |item| var << pow((item - a_mean), 2) }
            var
        end

        def verify_not_empty
            if size == 0
                raise EmptyImageException, 'computing statistics on an empty Image'
            end
        end

        def statistics
            keys = [:mean, :median, :variance, :standard_deviation]
            values = keys.map { |key| self.send(key) }
            Hash[ keys.zip(values) ]
        end

        def statistics_as_text
            statistics.map do |key, value|
                "#{replace_underscores_and_capitalize(key)}: #{value}"
            end
        end

        # 
        # html format interface for statistics output 
        # 
        # @return statistics_as_html
        # 
        def statistics_as_html
            title = "Statistics on Image"
            @builder ||= Builder::XmlMarkup.new(:indent => 2)
            @builder.declare! :DOCTYPE, :html
            @builder.html do
                @builder.head{ @builder.title title }
                @builder.body do
                    @builder.h1 title
                    statistics.each do |key, value|
                        @builder.p "#{replace_underscores_and_capitalize(key)}: #{value}"
                    end
                end
            end
        end

        # 
        # xml format interface for statistics output 
        # 
        # @return statistic_as_xml
        # 
        def statistics_as_xml
            @builder ||= Builder::XmlMarkup.new(:indent => 2)
            @builder.instruct! # the instruct! method writes <?xml version="1.0" encoding="UTF-8"?>
            @builder.image do
                @builder.data 'array' => map{ |number| number.to_s }.join(',')
                @builder.statistics do
                    statistics.each do |key, value|
                        @builder.statistic key => value
                    end
                end
            end
        end

        alias :average :mean

        private 

        def check_bounds(x, y)
            if (x + y * @number_of_rows) > size || x >= number_of_rows || y >= number_of_cols
                message = "[x, y] should be within [0..#{number_of_rows - 1}, 0..#{number_of_cols - 1}]"
                raise OutOfBoundsException, message
            end
        end

        def sort_data
            @data.sort
        end

        def sqrt(input)
            input ** 0.5
        end

        def pow(input, power)
            input ** power
        end

        def replace_underscores_and_capitalize(key)
            key.to_s.split("_").map { |word| word.capitalize}.join( " ")
        end
          
    end
end
