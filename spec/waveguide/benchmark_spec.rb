require "spec_helper"

RSpec.describe Waveguide do
  describe "benchmark" do
    [3, 30, 300].each do |record_count|
      context "with #{record_count} leagues" do
        let(:object_count) { 1 + record_count + (record_count * 28) }

        let(:league) do 
          League.new(
            full_name: "National Basketball League",
            slug: "NBA",
            events: EventFactory.create_many(record_count)
          )
        end

        it "benchmarks serializing #{record_count} leagues using Presenters" do
          hash = {}
          benchmark("#{record_count}x Events (#{object_count} objects) (Presenter)") do
            hash = LeaguePresenter.new(league).as_json
          end
          assert_output_structure(hash, record_count)
        end

        it "benchmarks serializing #{record_count} leagues using Waveguide" do
          hash = {}
          benchmark("#{record_count}x Events (#{object_count} objects) (Waveguide)") do
            hash = WaveguideLeagueSerializer.new(league).as_json
          end
          assert_output_structure(hash, record_count)
        end

        it "benchmarks serializing #{record_count} leagues using AMS" do
          hash = {}
          benchmark("#{record_count}x Events (#{object_count} objects) (AMS)") do
            hash = AMSLeagueSerializer.new(league).as_json
          end
          assert_output_structure(hash, record_count)
        end
      end
    end

    def assert_output_structure(hash, record_count)
      # League
      league = hash
      expect(league).to have_key(:id)
      expect(league).to have_key(:full_name)
      expect(league).to have_key(:slug)
      expect(league).to have_key(:events)

      # Event
      event = hash[:events].first
      expect(event).to have_key(:id)
      expect(event).to have_key(:start_date)
      expect(event).to have_key(:end_date)
      expect(event).to have_key(:title)
      expect(event).to have_key(:players)

      # Player
      player = hash[:events].first[:players].first
      expect(player).to have_key(:id)
      expect(player).to have_key(:full_name)
      expect(player).to have_key(:first_name)
      expect(player).to have_key(:last_name)
      expect(player).to have_key(:country)

      expect(player).not_to have_key(:birthdate)

      # Country
      country = hash[:events].first[:players].first[:country]
      expect(country).to have_key(:id)
      expect(country).to have_key(:country_code)
      expect(country).to have_key(:flag_url)

      # Item Counts
      expect(hash[:events].size).to eq(record_count)
      expect(hash[:events].first[:players].size).to eq(28)
    end

  end
end