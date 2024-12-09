class WorkAuthor < ApplicationRecord
  belongs_to :work
  belongs_to :author

  validates :work_id, uniqueness: { scope: :author_id }

  def self.attributes_from_open_library_json(json)
    work_external_identifier, authors = json.values_at("key", "authors")
    authors ||= [] # Not all works have authors, and this key is then omitted from the source data
    author_external_identifiers = authors.filter_map do |author_json|
      author_json.dig("author", "key")
    end

    { work_external_identifier:, author_external_identifiers: }
  end
end
