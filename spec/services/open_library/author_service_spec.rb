RSpec.describe OpenLibrary::AuthorService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_authors.txt") }
  let(:expected_authors) do
    {
      "/authors/OL10000000A" => "Patricia Pagac",
      "/authors/OL10000001A" => "Devin Witting VM",
      "/authors/OL10000002A" => "Madison Flatley",
      "/authors/OL10000003A" => "Sanora Schaden",
      "/authors/OL10000004A" => "Marylin Jacobson",
      "/authors/OL10000005A" => "Sen. Heath Cole",
      "/authors/OL10000006A" => "Carol Nolan DDS",
      "/authors/OL10000007A" => "Darrick Grimes",
      "/authors/OL10000008A" => "Lana Kuhic",
      "/authors/OL10000009A" => "Edward Gusikowski"
    }
  end

  describe '#call' do
    subject(:call) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call }.to change(Author, :count).by(10)

        expected_authors.each do |external_identifier, name|
          expect(Author.exists?(external_identifier:, name:)).to be true
        end
      end
    end

    context 'with existing records' do
      before do
        create(:author, name: "Patricia Pagac", external_identifier: "/authors/OL10000000A")
        create(:author, name: "Darrick Grimes", external_identifier: "/authors/OL10000007A")
      end

      it 'upserts existing records' do
        expect { call }.to change(Author, :count).by(8)

        expected_authors.each do |external_identifier, name|
          expect(Author.exists?(external_identifier:, name:)).to be true
        end
      end
    end
  end
end
