RSpec.describe Work, type: :model do
  subject(:work) { build(:work) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:title) { Faker::Book.title }
    let(:external_identifier) { "/works/OL1234567W" }

    let(:json) do
      {
        "title" => title,
        "covers" => [ 123456 ],
        "key" => external_identifier,
        "authors" => [
          {
            "type" => { "key" => "/type/author_role" },
            "author" => { "key" => "/authors/OL3964955A" }
          }
        ],
        "type" => { "key" => "/type/work" },
        "subjects" => Array.new(2) { Faker::Book.genre },
        "latest_revision" => 1,
        "revision" => 1,
        "created" => { "type" => "/type/datetime", "value" => "2009-12-11T01:57:19.964652" },
        "last_modified" => { "type" => "/type/datetime", "value" => "2024-09-05T08:23:28.496665" }
      }
    end

    it "generates attributes for a work" do
      expect(attributes).to include(title:, external_identifier:)
    end
  end
end
