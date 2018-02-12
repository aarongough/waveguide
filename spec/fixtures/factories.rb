NAMES = [
  "Aaron", "Bob", "Charlie", "Darren", "Edgar", "Frank", "Garret",
  "Hanzo", "Inushi", "Jack", "Karen", "Lando", "Montery", "Nedson"
]

COUNTRY_CODES = ["AU", "GB", "US", "FR", "BR", "IS", "AN", "AQ"]


class BaseFactory
  def self.create_many(count = 1)
    count.times.map do |x|
      self.create_one
    end
  end
end

class LeagueFactory < BaseFactory
  def self.create_one
    League.new(
      full_name: "National Basketball League",
      slug:  "NBA",
      events:  EventFactory.create_many(82)
    )
  end
end

class EventFactory < BaseFactory
  def self.create_one
    Event.new(
      title: "NBA Event",
      start_date: Time.now,
      end_date: Time.now,
      players: PlayerFactory.create_many(28)
    )
  end
end

class PlayerFactory < BaseFactory
  def self.create_one
    Player.new(
      first_name: NAMES.shuffle.first,
      last_name: NAMES.shuffle.first, 
      birthdate: Time.now, 
      country: CountryFactory.create_one
    )
  end
end

class CountryFactory < BaseFactory
  def self.create_one
    Country.new(
      country_code: COUNTRY_CODES.shuffle.first
    )
  end  
end