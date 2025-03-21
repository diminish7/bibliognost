RSpec.describe Subject, type: :model do
  subject(:subject) { build(:subject) }

  describe '.attributes_from_open_library_json' do
    subject(:attributes) { described_class.attributes_from_open_library_json(json) }

    let(:subjects) { Array.new(2) { Faker::Book.genre } }

    let(:json) do
      {
        "title" => Faker::Book.title,
        "covers" => [ 123456 ],
        "key" => "/works/OL1234567W",
        "authors" => [
          {
            "type" => { "key" => "/type/author_role" },
            "author" => { "key" => "/authors/OL3964955A" }
          }
        ],
        "type" => { "key" => "/type/work" },
        "subjects" => subjects,
        "latest_revision" => 1,
        "revision" => 1,
        "created" => { "type" => "/type/datetime", "value" => "2009-12-11T01:57:19.964652" },
        "last_modified" => { "type" => "/type/datetime", "value" => "2024-09-05T08:23:28.496665" }
      }
    end

    it "generates subjects for a work" do
      expect(attributes).to include(subjects:)
    end
  end
end
