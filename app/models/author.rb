class Author < ApplicationRecord
  validates :name, presence: true
  validates :external_identifier, uniqueness: true, allow_nil: true

  def self.attributes_from_open_library_json(json)
    name, external_identifier = json.values_at("name", "key")

    { name:, external_identifier: }
  end
end
