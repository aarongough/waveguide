class BaseModel < ActiveModelSerializers::Model
  def id
    self.object_id
  end
end

class League < BaseModel
  attr_accessor :events, :full_name, :slug
end

class Event < BaseModel
  attr_accessor :players, :start_date, :end_date, :title
end

class Player < BaseModel
  attr_accessor :first_name, :last_name, :birthdate, :country
end

class Country < BaseModel
  attr_accessor :country_code
end