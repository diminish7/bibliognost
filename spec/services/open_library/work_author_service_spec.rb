RSpec.describe OpenLibrary::WorkAuthorService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_works.txt") }
  let(:works) do
    {
      "/works/OL10000000W" => {
        title: "An Evil Cradling",
        authors: [ "/authors/OL1000000A" ]
      },
      "/works/OL10000001W" => {
        title: "The Mirror Crack'd from Side to Side",
        authors: [ "/authors/OL1000001A" ]
      },
      "/works/OL10000002W" => {
        title: "Pale Kings and Princes",
        authors: [ "/authors/OL1000002A" ]
      },
      "/works/OL10000003W" => {
        title: "The Golden Apples of the Sun",
        authors: [ "/authors/OL1000003A" ]
      },
      "/works/OL10000004W" => {
        title: "Where Angels Fear to Tread",
        authors: [ "/authors/OL1000004A" ]
      },
      "/works/OL10000005W" => {
        title: "The House of Mirth",
        authors: [ "/authors/OL1000005A" ]
      },
      "/works/OL10000006W" => {
        title: "The Millstone",
        authors: [ "/authors/OL1000006A" ]
      },
      "/works/OL10000007W" => {
        title: "Rosemary Sutcliff",
        authors: [ "/authors/OL1000007A" ]
      },
      "/works/OL10000008W" => {
        title: "The Needle's Eye",
        authors: [ "/authors/OL1000008A" ]
      },
      "/works/OL10000009W" => {
        title: "Lilies of the Field",
        authors: [ "/authors/OL1000009A", "/authors/OL1000010A" ]
      }
    }
  end

  before do
    # Insert all works as if the work service has already run
    works.each do |external_identifier, attrs|
      title = attrs[:title]
      create(:work, external_identifier:, title:)
      attrs[:authors].each do |external_identifier|
        create(:author, external_identifier:)
      end
    end
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(WorkAuthor, :count).by(11)

        works.each do |external_identifier, attrs|
          authors = attrs[:authors].map do |external_identifier|
            Author.find_by(external_identifier:)
          end
          work_authors = Work.find_by(external_identifier:).authors
          expect(work_authors).to contain_exactly(*authors)
        end
      end
    end

    context 'with existing records' do
      before do
        work = Work.find_by(external_identifier: "/works/OL10000000W")
        work.update!(authors: [ Author.find_by(external_identifier: "/authors/OL1000000A") ])
        work = Work.find_by(external_identifier: "/works/OL10000008W")
        work.update!(authors: [ Author.find_by(external_identifier: "/authors/OL1000008A") ])
      end

      it 'upserts existing records' do
        expect { call_it }.to change(WorkAuthor, :count).by(9)

        works.each do |external_identifier, attrs|
          authors = attrs[:authors].map do |external_identifier|
            Author.find_by(external_identifier:)
          end
          work_authors = Work.find_by(external_identifier:).authors
          expect(work_authors).to contain_exactly(*authors)
        end
      end
    end
  end
end
