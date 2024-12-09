class Subject < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.attributes_from_open_library_json(json)
    { subjects: json["subjects"] }
  end
end
