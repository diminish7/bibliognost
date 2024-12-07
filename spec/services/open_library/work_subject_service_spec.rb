RSpec.describe OpenLibrary::WorkSubjectService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_works.txt") }
  let(:works) do
    {
      "/works/OL10000000W" => {
        title: "An Evil Cradling",
        subjects: [ "Essay", "Folklore" ]
      },
      "/works/OL10000001W" => {
        title: "The Mirror Crack'd from Side to Side",
        subjects: [ "Humor", "Legend", "Fable" ]
      },
      "/works/OL10000002W" => {
        title: "Pale Kings and Princes",
        subjects: [ "Horror", "Fantasy" ]
      },
      "/works/OL10000003W" => {
        title: "The Golden Apples of the Sun",
        subjects: [ "Realistic fiction" ]
      },
      "/works/OL10000004W" => {
        title: "Where Angels Fear to Tread",
        subjects: [ "Textbook", "Western", "Horror" ]
      },
      "/works/OL10000005W" => {
        title: "The House of Mirth",
        subjects: [ "Mystery" ]
      },
      "/works/OL10000006W" => {
        title: "The Millstone",
        subjects: [ "Classic" ]
      },
      "/works/OL10000007W" => {
        title: "Rosemary Sutcliff",
        subjects: [ "Metafiction" ]
      },
      "/works/OL10000008W" => {
        title: "The Needle's Eye",
        subjects: [ "Short story", "Metafiction", "Fiction narrative" ]
      },
      "/works/OL10000009W" => {
        title: "Lilies of the Field",
        subjects: [ "Fiction in verse", "Metafiction" ]
      }
    }
  end

  before do
    # Insert all works as if the work service has already run
    works.each do |external_identifier, attrs|
      title = attrs[:title]
      create(:work, external_identifier:, title:)
    end
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(Subject, :count).by(16).and change(WorkSubject, :count).by(19)

        works.each do |external_identifier, attrs|
          subjects = attrs[:subjects]
          work_subjects = Work.find_by(external_identifier:).subjects.map(&:name)
          expect(work_subjects).to contain_exactly(*subjects)
        end
      end
    end

    context 'with existing records' do
      before do
        work = Work.find_by(external_identifier: "/works/OL10000000W")
        work.update!(subjects: [
          create(:subject, name: "Essay"),
          create(:subject, name: "Folklore")
        ])
        work = Work.find_by(external_identifier: "/works/OL10000008W")
        work.update!(subjects: [
          create(:subject, name: "Short story"),
          create(:subject, name: "Metafiction"),
          create(:subject, name: "Fiction narrative")
        ])
      end

      it 'upserts existing records' do
        expect { call_it }.to change(Subject, :count).by(11).and change(WorkSubject, :count).by(14)

        works.each do |external_identifier, attrs|
          subjects = attrs[:subjects]
          work_subjects = Work.find_by(external_identifier:).subjects.map(&:name)
          expect(work_subjects).to contain_exactly(*subjects)
        end
      end
    end
  end
end
