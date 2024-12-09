RSpec.describe OpenLibrary::SubjectService, type: :service do
  subject(:service) { described_class.new(fixture_path) }

  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_works.txt") }
  let(:subjects) do
    [
      "Essay",
      "Folklore",
      "Humor",
      "Legend",
      "Fable",
      "Horror",
      "Fantasy",
      "Realistic fiction",
      "Textbook",
      "Western",
      "Mystery",
      "Classic",
      "Metafiction",
      "Short story",
      "Fiction narrative",
      "Fiction in verse"
    ]
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(Subject, :count).by(16)

        subjects.each do |name|
          expect(Subject.exists?(name:)).to be true
        end
      end
    end

    context 'with existing records' do
      before do
        create(:subject, name: "Essay")
        create(:subject, name: "Fiction narrative")
      end

      it 'upserts existing records' do
        expect { call_it }.to change(Subject, :count).by(14)

        subjects.each do |name|
          expect(Subject.exists?(name:)).to be true
        end
      end
    end
  end
end
