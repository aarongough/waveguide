require "spec_helper"

RSpec.describe Waveguide do
  describe "profile" do
    let!(:league) do
      League.new(
        full_name: "National Basketball League",
        slug: "NBA",
        events: EventFactory.create_many(100)
      )
    end

    it "profiles serialization of a simple object" do
      $profiles["Serializing league (Presenter)"] = RubyProf.profile do
        LeaguePresenter.new(league).as_json
      end

      $profiles["Serializing league (Waveguide)"] = RubyProf.profile do
        WaveguideLeagueSerializer.new(league).as_json
      end
      
      $profiles["Serializing league (AMS)"] = RubyProf.profile do
        AMSLeagueSerializer.new(league).as_json
      end
    end

  end
end