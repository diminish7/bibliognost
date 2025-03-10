RSpec.describe Publisher, type: :model do
  subject(:publisher) { build(:publisher) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:json) { { "publishers" => [ publisher ] } }

    context "with a reasonably sized publisher" do
      let(:publisher) { Faker::Company.name }

      it "generates attributes for a publisher" do
        expect(attributes).to include(name: publisher, description: nil)
      end
    end

    context "with a big publisher name (junk data)" do
      let(:publisher) do
        name = Faker::Company.name
        name = "#{name} #{Faker::Company.name}" while name.bytes.length <= 255
        name
      end

      let(:truncated) { publisher[0...255] }

      it "truncates the name and puts the full name in description" do
        expect(attributes).to include(name: truncated, description: publisher)
      end
    end
  end
end
