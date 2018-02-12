class BasePresenter
  attr_reader :object, :scope

  def initialize(object, scope = nil)
    @object = object
    @scope = scope
  end
end

class CountryPresenter < BasePresenter
  def as_json
    {
      id: object.id,
      flag_url: flag_url,
      country_code: object.country_code
    }
  end

  def flag_url
    "http://assets.static.com/flags/#{object.country_code}"
  end
end

class PlayerPresenter < BasePresenter
  def as_json
    json = {
      id: object.id,
      full_name: full_name,
      first_name: object.first_name,
      last_name: object.last_name,
    }

    json[:country] = country if object.respond_to?(:country)
    json[:birthdate] = object.birthdate if false

    json
  end

  def country
    CountryPresenter.new(object.country).as_json
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end
end

class EventPresenter < BasePresenter
  def as_json
    {
      id: object.id,
      start_date: object.start_date,
      end_date: object.end_date,
      title: object.title,
      players: players
    }
  end

  def players
    object.players.map { |player| PlayerPresenter.new(player).as_json }
  end
end

class LeaguePresenter < BasePresenter
  def as_json
    {
      id: object.id,
      full_name: object.full_name,
      slug: object.slug,
      events: events
    }
  end

  def events
    object.events.map { |event| EventPresenter.new(event).as_json }
  end
end
