class Work < ApplicationRecord
  include HasExternalIdentifier

  has_many :editions, dependent: :destroy

  has_many :work_subjects, dependent: :destroy
  has_many :subjects, through: :work_subjects

  has_many :work_authors, dependent: :destroy
  has_many :authors, through: :work_authors

  validates :title, presence: true

  def self.attributes_from_open_library_json(json)
    title, external_identifier = json.values_at("title", "key")

    { title:, external_identifier: }
  end
end
