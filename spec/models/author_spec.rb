RSpec.describe Author, type: :model do
  subject(:author) { build(:author) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:name) { Faker::Name.name }
    let(:external_identifier) { "/authors/OL1234567A" }
    let(:json) do
      {
        "type" => { "key" => "/type/author" },
        "name" => name,
        "key" => external_identifier,
        "source_records" => %w[bwb:9781780781129],
        "latest_revision" => 1,
        "revision" => 1,
        "created" => { "type" => "/type/datetime", "value" => "2021-12-26T20:45:19.295603" },
        "last_modified" => { "type" => "/type/datetime", "value" => "2021-12-26T20:45:19.295603" }
      }
    end

    it "generates an author" do
      expect(attributes).to include(name:, external_identifier:)
    end
  end
end
