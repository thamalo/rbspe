module Rbspe
  
  HEAD = { :@version => [1992, 'F'], :@xdim => [42, 'v'], :@ydim => [656, 'v'], :@xDimDet => [6, 'v'],
            :@yDimDet => [18, 'v'], :@datatype => [108, 's_'], :@numFrames => [1446, 'l_'],
            :@noscan => [34, 's_'], :@lnoscan => [664, 'l_'], :@winView_id => [2996, 'l_'],
            :@scramble => [658, 's_'], :@lastvalue => [4098, 's_'], :@xmlFooterOffset => [667, 'S'] }
  
  DATATYPE = {0 => [4, 'F'], 1 => [4, 'l_'], 2 => [2, 's'], 3 => [2, 'S'], 8 => [4, 'L']}
  SIZE = 8 # Default bytes size for fread to avoid reading all the rest of the file
  module FRead
    def read_data(file, size, offset, directive)
      file.seek offset
      file.read(size).unpack(directive)
      # file.read.unpack(directive) # Lis jusqu'a la fin pas ce qu'on veut ici
    end
  end
  class Header
    include FRead
    attr_accessor :version, :xdim, :ydim, :xDimDet,
                  :yDimDet, :datatype, :numFrames,
                  :noscan, :lnoscan, :winView_id,
                  :scramble, :lastvalue 
                  
    def initialize(file)
      open file, 'rb' do |f|
        get_head(f) 
      end
    end
    
    def display_infos
      HEAD.each_key do |key|
        printf "%-15s: %s\n" , key.to_s.sub("@", ""), "#{instance_variable_get key}"
      end
    end
    
    def get_head(file)
        HEAD.each_pair do |key, value|
         instance_variable_set(key,read_data(file, SIZE, value[0], value[1])[0])
        end
    end
    
  end 
  
end 