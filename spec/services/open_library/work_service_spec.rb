RSpec.describe OpenLibrary::WorkService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_works.txt") }
  let(:expected_works) do
    {
      "/works/OL10000000W" => "An Evil Cradling",
      "/works/OL10000001W" => "The Mirror Crack'd from Side to Side",
      "/works/OL10000002W" => "Pale Kings and Princes",
      "/works/OL10000003W" => "The Golden Apples of the Sun",
      "/works/OL10000004W" => "Where Angels Fear to Tread",
      "/works/OL10000005W" => "The House of Mirth",
      "/works/OL10000006W" => "The Millstone",
      "/works/OL10000007W" => "Rosemary Sutcliff",
      "/works/OL10000008W" => "The Needle's Eye",
      "/works/OL10000009W" => "Lilies of the Field"
    }
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(Work, :count).by(10)

        expected_works.each do |external_identifier, title|
          expect(Work.exists?(external_identifier:, title:)).to be true
        end
      end
    end

    context 'with existing records' do
      before do
        create(:work, title: "An Evil Cradling", external_identifier: "/works/OL10000000W")
        create(:work, title: "The House of Mirth", external_identifier: "/works/OL10000005W")
      end

      it 'upserts existing records' do
        expect { call_it }.to change(Work, :count).by(8)

        expected_works.each do |external_identifier, title|
          expect(Work.exists?(external_identifier:, title:)).to be true
        end
      end
    end
  end
end
