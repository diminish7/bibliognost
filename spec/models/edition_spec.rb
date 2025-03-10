RSpec.describe Edition, type: :model do
  subject(:edition) { build(:edition) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:title) { Faker::Book.title }
    let(:external_identifier) { "/books/OL1234567M" }
    let(:author_external_identifier) { "/authors/OL10000A" }
    let(:work_external_identifier) { "/works/OL10000W" }
    let(:publisher) { Faker::Book.publisher }
    let(:published_at) { Date.new(2024, 12, 27) }
    let(:contributors) { [ Faker::Name.name, Faker::Name.name ] }
    let(:pages) { 357 }
    let(:word_count) { 89_000 }
    let(:isbn_10) { Faker::Code.isbn(base: 10).remove("-") }
    let(:isbn_13) { Faker::Code.isbn(base: 13).remove("-") }

    let(:json) do
      {
        "title" => title,
        "authors" => [ { "key" => author_external_identifier } ],
        "works" => [ { "key" => work_external_identifier } ],
        "publish_date" => published_at.strftime("%B %e, %Y"),
        "publishers" => [ publisher ],
        "covers" => [ 8739161 ],
        "contributions" => contributors,
        "languages" => [ { "key" => "/languages/eng" } ],
        "key" => external_identifier,
        "number_of_pages" => pages,
        "word_count" => word_count,
        "isbn_10" => [ isbn_10 ],
        "isbn_13" => [ isbn_13 ]
      }
    end

    it "generates attributes for a work" do
      expect(attributes).to include(
        work_external_identifier: work_external_identifier,
        publisher_name: publisher,
        title:,
        external_identifier:,
        published_at:,
        contributors:,
        pages:,
        word_count:,
        isbn_10:,
        isbn_13:
      )
    end
  end
end
