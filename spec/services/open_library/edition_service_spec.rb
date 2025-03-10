RSpec.describe OpenLibrary::EditionService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_editions.txt") }
  let(:expected_editions) do
    {
      "/books/OL10000000M" => "An Instant In The Wind",
      "/books/OL10000001M" => "Bury My Heart at Wounded Knee",
      "/books/OL10000002M" => "A Catskill Eagle",
      "/books/OL10000003M" => "Bury My Heart at Wounded Knee (book 2)",
      "/books/OL10000004M" => "Françoise Sagan",
      "/books/OL10000005M" => "Ah, Wilderness!",
      "/books/OL10000006M" => "That Good Night",
      "/books/OL10000007M" => "A Swiftly Tilting Planet",
      "/books/OL10000008M" => "Let Us Now Praise Famous Men",
      "/books/OL10000009M" => "Mother Night"
    }
  end

  before do
    # Create the expected subjects
    create(:subject, name: "Action/Adventure")
    create(:subject, name: "Classic")
    create(:subject, name: "Comic")
    create(:subject, name: "Fairy tale")
    create(:subject, name: "Graphic Novel")
    create(:subject, name: "Horror")
    create(:subject, name: "Humor")
    create(:subject, name: "Law")
    create(:subject, name: "Realistic Fiction")
    create(:subject, name: "Reference")
    create(:subject, name: "Suspense")
    create(:subject, name: "Thriller")
    # Create the expected publishers
    create(:publisher, name: "D'Amore Inc")
    create(:publisher, name: "Jast-Kuhic")
    create(:publisher, name: "Ortiz and Sons")
    create(:publisher, name: "Bergstrom-Breitenberg")
    create(:publisher, name: "Fritsch, Mohr and Kunde")
    create(:publisher, name: "Bailey-Lockman")
    create(:publisher, name: "D'Amore, Hegmann and Reichel")
    create(:publisher, name: "Hoppe, Considine and Heaney")
    # Create the expected works
    create(:work, external_identifier: "/works/OL10000000W")
    create(:work, external_identifier: "/works/OL10000001W")
    create(:work, external_identifier: "/works/OL10000002W")
    create(:work, external_identifier: "/works/OL10000003W")
    create(:work, external_identifier: "/works/OL10000004W")
    create(:work, external_identifier: "/works/OL10000005W")
    create(:work, external_identifier: "/works/OL10000006W")
    create(:work, external_identifier: "/works/OL10000007W")
    create(:work, external_identifier: "/works/OL10000008W")
    create(:work, external_identifier: "/works/OL10000009W")
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(Edition, :count).by(10)

        expected_editions.each do |external_identifier, title|
          expect(Edition.exists?(external_identifier:, title:)).to be true
        end
      end

      it 'inserts the correct fields' do
        call_it
        edition = Edition.find_by(external_identifier: '/books/OL10000000M')

        expect(edition).to have_attributes(
          title: 'An Instant In The Wind',
          isbn_10: '1000000001',
          isbn_13: '1000000000001',
          work: Work.find_by!(external_identifier: '/works/OL10000000W'),
          publisher: Publisher.find_by!(name: "D'Amore Inc"),
          subtitle: 'A novel'
        )
      end
    end

    context 'with existing records' do
      before do
        create(:edition, title: "Bury My Heart (old title)", external_identifier: "/books/OL10000001M")
        create(:edition, title: "Françoise Sagan (old title)", external_identifier: "/books/OL10000004M")
      end

      it 'upserts existing records' do
        expect { call_it }.to change(Edition, :count).by(8)

        expected_editions.each do |external_identifier, title|
          expect(Edition.exists?(external_identifier:, title:)).to be true
        end
      end
    end
  end
end
