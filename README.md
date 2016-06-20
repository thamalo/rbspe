# Rbspe

Read Princeton Instrument *.SPE scientific images implemented in plain ruby.

Image is returned as a 2D array. 

Statistical computation can be performed in the returned Image object. 

Support Spe3 Version


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbspe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbspe

## Usage

ImageReader parse the spe file and return an image object

```ruby
require 'rbspe'

image = RbSpe::ImageReader.new("1024x512_spe_image.spe")
puts image.number_of_rows # => 1024
puts image.number_of_cols # => 512
```

Header contents the header information of the spefile

```ruby
require 'rbspe'

header = RbSpe::Header.new("spefile.spe")
header.display_infos # print the informations on the header of file.spe
``` 
Image object can be initilize with an array too

```ruby
require 'rbspe'

image = Rbspe::Image.new(2, 2, [1, 2, 3, 4])
puts image.mean # => 2.5
puts image.sum # => 10


image[0,0] = 2
puts image[0,2] # => 2
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rbspe. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

