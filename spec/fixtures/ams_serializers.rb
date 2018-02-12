class AMSBaseSerializer < ActiveModel::Serializer
  attribute :id
end

class AMSCountrySerializer < AMSBaseSerializer
  attributes :flag_url, :country_code

  def flag_url
    "http://assets.static.com/flags/#{object.country_code}"
  end
end

class AMSPlayerSerializer < AMSBaseSerializer
  has_one :country, serializer: AMSCountrySerializer, if: :country?
  attributes :full_name, :first_name, :last_name
  attribute :birthdate, if: :birthdate?

  def country?
    object.respond_to?(:country)
  end

  def birthdate?
    false
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end
end

class AMSEventSerializer < AMSBaseSerializer
  attributes :start_date, :end_date, :title, :players

  def players
    object.players.map do |player|
      AMSPlayerSerializer.new(player).as_json
    end
  end
end

class AMSLeagueSerializer < AMSBaseSerializer
  has_many :events, serializer: AMSEventSerializer
  attributes :full_name, :slug
end
