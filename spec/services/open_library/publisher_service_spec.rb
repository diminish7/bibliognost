RSpec.describe OpenLibrary::PublisherService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_editions.txt") }
  let(:expected_publishers) do
    # 10 records, excluding 2 dups
    [
      "D'Amore Inc",
      "Jast-Kuhic",
      "Ortiz and Sons",
      "Bergstrom-Breitenberg",
      "Fritsch, Mohr and Kunde",
      "Bailey-Lockman",
      "D'Amore, Hegmann and Reichel",
      "Hoppe, Considine and Heaney"
    ]
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(Publisher, :count).by(8)

        expected_publishers.each do |name|
          expect(Publisher.exists?(name:)).to be true
        end
      end
    end

    context 'with existing records' do
      before do
        create(:publisher, name: "Jast-Kuhic")
        create(:publisher, name: "D'Amore, Hegmann and Reichel")
      end

      it 'upserts existing records' do
        expect { call_it }.to change(Publisher, :count).by(6)

        expected_publishers.each do |name|
          expect(Publisher.exists?(name:)).to be true
        end
      end
    end
  end
end
