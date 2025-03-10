RSpec.describe EditionAuthor, type: :model do
  subject(:edition_author) { build(:edition_author) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:author1_external_identifier) { "/authors/OL3964955A" }
    let(:author2_external_identifier) { "/authors/OL8675541A" }

    let(:edition_external_identifier) { "/books/OL1234567M" }
    let(:author_external_identifiers) do
      [ author1_external_identifier, author2_external_identifier ]
    end

    let(:json) do
      {
        "title" => Faker::Book.title,
        "covers" => [ 123456 ],
        "key" => edition_external_identifier,
        "authors" => [
          { "key" => author1_external_identifier },
          { "key" => author2_external_identifier }
        ],
        "type" => { "key" => "/type/edition" },
        "subjects" => [ "History" ],
        "latest_revision" => 1,
        "revision" => 1,
        "created" => { "type" => "/type/datetime", "value" => "2009-12-11T01:57:19.964652" },
        "last_modified" => { "type" => "/type/datetime", "value" => "2024-09-05T08:23:28.496665" }
      }
    end

    it "generates attributes for a edition" do
      expect(attributes).to include(edition_external_identifier:, author_external_identifiers:)
    end
  end
end
