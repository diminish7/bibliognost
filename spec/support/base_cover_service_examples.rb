# Shared examples for things that have attached covers (works and editions)
# Assumes a let(:coverables) is defined with a map of parent identifier to titles and covers
RSpec.shared_examples_for OpenLibrary::BaseCoverService do
  subject(:service) { described_class.new(fixture_path) }

  let(:parent_model) { described_class.name.demodulize.delete_suffix('CoverService').constantize }
  let(:factory) { parent_model.model_name.singular.to_sym }
  let(:fixture_path) { Rails.root.join("spec/fixtures/dumps/ol_#{factory.to_s.pluralize}.txt") }

  before do
    # Insert all parent models as if their service has already run
    coverables.each do |external_identifier, attrs|
      title = attrs[:title]
      create(factory, external_identifier:, title:)
    end
  end

  describe '#call' do
    subject(:call_it) { service.call }

    context 'with no records' do
      it 'inserts all records' do
        expect { call_it }.to change(ActiveStorage::Blob, :count).by(11)

        coverables.each do |external_identifier, attrs|
          parent = parent_model.find_by(external_identifier:)
          attrs[:covers].each do |cover_id|
            filename = "#{"%010d" % cover_id}-M.jpg"
            cover = parent.covers.detect { |cover| cover.filename == filename }
            expect(cover).to be_present
          end
        end
      end
    end

    context 'with existing records' do
      before do
        coverable1 = coverables.keys[0]
        coverable9 = coverables.keys[8]
        [ coverable1, coverable9 ].each do |external_identifier|
          parent = parent_model.find_by(external_identifier:)
          coverables[external_identifier][:covers].each do |cover_id|
            filename = "#{"%010d" % cover_id}-M.jpg"
            path = Rails.root.join("db/dumps/covers/m_covers_0000/00/#{filename}")
            parent.covers.attach(io: File.open(path), filename:)
          end
        end
      end

      it 'upserts existing records' do
        expect { call_it }.to change(ActiveStorage::Blob, :count).by(9)

        coverables.each do |external_identifier, attrs|
          parent = parent_model.find_by(external_identifier:)
          attrs[:covers].each do |cover_id|
            filename = "#{"%010d" % cover_id}-M.jpg"
            cover = parent.covers.detect { |cover| cover.filename == filename }
            expect(cover).to be_present
          end
        end
      end
    end
  end
end
