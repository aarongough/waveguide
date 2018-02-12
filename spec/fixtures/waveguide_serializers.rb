class WaveguideBaseSerializer < Waveguide::Serializer
  attributes :id
end

class WaveguideCountrySerializer < WaveguideBaseSerializer
  attributes :country_code, :flag_url

  attribute :flag_url do
    "http://assets.static.com/flags/#{object.country_code}"
  end
end

class WaveguidePlayerSerializer < WaveguideBaseSerializer
  has_one :country, serializer: WaveguideCountrySerializer
  attributes :first_name, :last_name, :full_name, :birthdate

  attribute :full_name do
    "#{object.first_name} #{object.last_name}"
  end

  include? :country do 
    object.respond_to?(:country)
  end

  include? :birthdate do
    false
  end
end

class WaveguideEventSerializer < WaveguideBaseSerializer
  has_many :players, serializer: WaveguidePlayerSerializer
  attributes :start_date, :end_date, :title
end

class WaveguideLeagueSerializer < WaveguideBaseSerializer
  has_many :events, serializer: WaveguideEventSerializer
  attributes :full_name, :slug
end