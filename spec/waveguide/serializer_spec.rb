require "spec_helper"

RSpec.describe Waveguide::Serializer do
  before do
    described_class.attributes_to_serialize = []
    described_class.conditional_attributes = []
    described_class.serializer_methods = {}
  end

  describe "#initialize" do
    it "should allow initializing and getting of object" do
      serializer = described_class.new(:object)
      expect(serializer.object).to eq(:object)
    end

    it "should allow initializing and getting of scope" do
      serializer = described_class.new(:object, :scope)
      expect(serializer.scope).to eq(:scope)
    end
  end

  describe "#as_json" do
    let(:country) do
      double(:country, id: 123, country_code: "UK")
    end

    let(:test_object) do
      double(:player,
        id: 12,
        first_name: "Josh",
        last_name: "Foley",
        age: 32,
        country: country,
        parents: [
          double(:person,
            id: 13,
            first_name: "Bob",
            last_name: "Foley",
            age: 65,
            country: country
          ), double(:person,
            id: 14,
            first_name: "Marge",
            last_name: "Foley",
            age: 58,
            country: country
          )
        ]
      )
    end

    context "with no attributes" do
      it "return an empty hash" do
        expect(described_class.new(nil).as_json).to eq({})
      end
    end

    context "with a single attribute" do
      it "returns a serializable hash" do
        described_class.attribute :first_name
        expect(described_class.new(test_object).as_json).to eq({ first_name: "Josh" })
      end
    end

    context "with multiple attributes" do
      it "returns a serializable hash" do
        described_class.attributes :first_name, :age
        expect(described_class.new(test_object).as_json).to eq({ first_name: "Josh", age: 32 })
      end
    end

    context "with a block attribute" do
      it "returns a serializable hash" do
        described_class.attribute :full_name { "#{object.first_name} #{object.last_name}"}
        expect(described_class.new(test_object).as_json).to eq({ full_name: "Josh Foley" })
      end
    end

    context "with a has_one relationship" do
      it "returns a serializable hash" do
        described_class.has_one :country, serializer: WaveguideCountrySerializer

        expect(described_class.new(test_object).as_json).to eq({
          country: {
            id: 123,
            country_code: "UK",
            flag_url: "http://assets.static.com/flags/UK"
          }
        })
      end
    end
  end
end
