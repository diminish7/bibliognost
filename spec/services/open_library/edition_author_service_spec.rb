RSpec.describe OpenLibrary::EditionAuthorService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_editions.txt") }
  let(:editions) do
    {
      "/books/OL10000000M" => {
        title: "An Instant In The Wind",
        authors: [ "/authors/OL1000000A" ]
      },
      "/books/OL10000001M" => {
        title: "Bury My Heart at Wounded Knee",
        authors: [ "/authors/OL1000001A" ]
      },
      "/books/OL10000002M" => {
        title: "A Catskill Eagle",
        authors: [ "/authors/OL1000002A" ]
      },
      "/books/OL10000003M" => {
        title: "Bury My Heart at Wounded Knee (book 2)",
        authors: [ "/authors/OL1000003A" ]
      },
      "/books/OL10000004M" => {
        title: "Françoise Sagan",
        authors: [ "/authors/OL1000004A" ]
      },
      "/books/OL10000005M" => {
        title: "Ah, Wilderness!",
        authors: [ "/authors/OL1000005A" ]
      },
      "/books/OL10000006M" => {
        title: "That Good Night",
        authors: [ "/authors/OL1000006A" ]
      },
      "/books/OL10000007M" => {
        title: "A Swiftly Tilting Planet",
        authors: [ "/authors/OL1000007A" ]
      },
      "/books/OL10000008M" => {
        title: "Let Us Now Praise Famous Men",
        authors: [ "/authors/OL1000008A" ]
      },
      "/books/OL10000009M" => {
        title: "Mother Night",
        authors: [ "/authors/OL1000009A", "/authors/OL1000010A" ]
      }
    }
  end

  before do
    # Insert all editions as if the edition service has already run
    editions.each do |external_identifier, attrs|
      title = attrs[:title]
      create(:edition, external_identifier:, title:)
      attrs[:authors].each do |external_identifier|
        create(:author, external_identifier:)
      end
    end
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(EditionAuthor, :count).by(11)

        editions.each do |external_identifier, attrs|
          authors = attrs[:authors].map do |external_identifier|
            Author.find_by(external_identifier:)
          end
          edition_authors = Edition.find_by(external_identifier:).authors
          expect(edition_authors).to contain_exactly(*authors)
        end
      end
    end

    context 'with existing records' do
      before do
        edition = Edition.find_by(external_identifier: "/books/OL10000000M")
        edition.update!(authors: [ Author.find_by(external_identifier: "/authors/OL1000000A") ])
        edition = Edition.find_by(external_identifier: "/books/OL10000008M")
        edition.update!(authors: [ Author.find_by(external_identifier: "/authors/OL1000008A") ])
      end

      it 'upserts existing records' do
        expect { call_it }.to change(EditionAuthor, :count).by(9)

        editions.each do |external_identifier, attrs|
          authors = attrs[:authors].map do |external_identifier|
            Author.find_by(external_identifier:)
          end
          edition_authors = Edition.find_by(external_identifier:).authors
          expect(edition_authors).to contain_exactly(*authors)
        end
      end
    end
  end
end
