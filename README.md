# Waveguide

Waveguide is a fast serializer library for Ruby. It's designed to be partly compatible with ActiveModelSerializers, but much faster:

```ruby
300x Events (8701 objects) (Waveguide)  : 111.56 ms
300x Events (8701 objects) (AMS)        : 774.62 ms
```

## Usage

```ruby
class PlayerSerializer < Waveguide::Serializer
  # define a single attribute
  attribute :first_name

  # override the source of an attribute with a block
  attribute :last_name { object.parent.last_name }

  attribute :full_name do
    "#{object.first_name} #{object.last_name}"
  end

  # define a list of attributes
  attributes :first_name, :last_name

  # define a singular relation
  has_one :country, serializer: CountrySerializer

  # define a singular relation with a different key name
  has_one :country, as: :origin_country, serializer: CountrySerializer  

  # define a multiple relation
  has_many :games, serializer: GameSerializer

  # define a multiple relation with a different key name
  has_many :games, as: :events, serializer: GameSerializer

  # conditionally include an attribute
  include? :country do 
    object.respond_to?(:country)
  end
end
```

Example:

```ruby
class EventSerializer < Waveguide::Serializer
  has_many :players, serializer: PlayerSerializer
  attributes :start_date, :end_date
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'waveguide'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install waveguide



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
