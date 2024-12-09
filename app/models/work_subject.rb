class WorkSubject < ApplicationRecord
  belongs_to :work
  belongs_to :subject

  validates :work_id, uniqueness: { scope: :subject_id }

  def self.attributes_from_open_library_json(json)
    title, work_external_identifier, subjects = json.values_at("title", "key", "subjects")

    { work_external_identifier:, subjects: }
  end
end
