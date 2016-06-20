require 'spec_helper'

describe Rbspe do
  it 'has a version number' do
    expect(Rbspe::VERSION).not_to be nil
  end
  describe "Spe Header attributes" do
	context 'When INT16 image' do
		let(:header) {Rbspe::Header.new('samples/INT16.SPE')}

		specify { expect(header.datatype).to eq(2) }
			
		specify { expect(header.version).to be_within(0.001).of(2.2) }
		specify { expect(header.xdim).to eq(1024) }
		specify { expect(header.ydim).to eq(1024) }
		specify { expect(header.xDimDet).to eq(1024) }
		specify { expect(header.yDimDet).to eq(1024) }
		specify { expect(header.numFrames).to eq(1) }
	end	
  end

  describe 'Image internal' do 
	describe '#mean' do 
		context 'image 2x2 [1, 2, 3, 4]' do
			input = [1, 2, 3, 4]
			dimx = 2
			dimy = 2
			let(:image) { Rbspe::Image.new(dimx, dimy, input) }
			it 'returns mean of 2.5' do
				expect(image.mean).to eq(2.5)
			end
		end
	end

	describe '#[]() and #[]=' do
		context 'When pixel 0,0 set to 500' do
			let(:image) { Rbspe::Image.new(2,2, [1,1,2,3])}
			it 'should content 500' do
				image[0,0] = 500
				expect(image[0,0]).to eq(500)
			end
		end
	end

	describe 'statistic methods' do
		context 'image 512 x 512 containing 200, 100 serie' do
			dimx, dimy = 512, 512
			image = Rbspe::Image.new(dimx, dimy, input_512x512)
			it 'retuns mean of 150.0' do
				expect(image.mean).to eq(150.0)
			end

			specify { expect(image.size).to eq(dimx*dimy) }

			specify { expect(image.standard_deviation).to eq(50.0) }

			specify { expect(image.median).to eq(150.0) }
		end
	end

	describe "ImageReader" do
		context 'When INT16 Image' do
			let(:int16_image) {Rbspe::ImageReader.read('samples/INT16.SPE')}

			it "should get the correct number of rows and columns" do
				expect(int16_image.number_of_rows).to eq(1024)
				expect(int16_image.number_of_cols).to eq(1024)
			end
			it 'should give the correct pixel value' do
				expect(int16_image[0,0]).to eq(-32705)
			end

			it "should raise OutOfBoundsException when invalid" do
				message = "[x, y] should be within [0..#{int16_image.number_of_rows - 1}, 0..#{int16_image.number_of_cols - 1}]"
				expect{int16_image[1025,0]}.to raise_exception(OutOfBoundsException, message)
			end
		end

	end
  end
end

