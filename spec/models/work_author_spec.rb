RSpec.describe WorkAuthor, type: :model do
  subject(:work_author) { build(:work_author) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:author1_external_identifier) { "/authors/OL3964955A" }
    let(:author2_external_identifier) { "/authors/OL8675541A" }

    let(:work_external_identifier) { "/works/OL1234567W" }
    let(:author_external_identifiers) do
      [ author1_external_identifier, author2_external_identifier ]
    end

    let(:json) do
      {
        "title" => Faker::Book.title,
        "covers" => [ 123456 ],
        "key" => work_external_identifier,
        "authors" => [
          {
            "type" => { "key" => "/type/author_role" },
            "author" => { "key" => author1_external_identifier }
          },
          {
            "type" => { "key" => "/type/author_role" },
            "author" => { "key" => author2_external_identifier }
          }
        ],
        "type" => { "key" => "/type/work" },
        "subjects" => [ "History" ],
        "latest_revision" => 1,
        "revision" => 1,
        "created" => { "type" => "/type/datetime", "value" => "2009-12-11T01:57:19.964652" },
        "last_modified" => { "type" => "/type/datetime", "value" => "2024-09-05T08:23:28.496665" }
      }
    end

    it "generates attributes for a work" do
      expect(attributes).to include(work_external_identifier:, author_external_identifiers:)
    end
  end
end
